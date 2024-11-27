import 'package:flutter/material.dart';
import 'Menu1.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool validacao = false;
  int userId = -1;

  @override
  void initState() {
    super.initState();
    // Pré-preencher os campos de email e senha
    _emailController.text = "miguel@gmail.com";
    _passwordController.text = "123123";
  }

  // Função para salvar os dados no SharedPreferences (sem o codAtributos)
  Future<void> salvarDados(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  // Função de login
  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Verifica se o email e senha são os pré-definidos
      if (_emailController.text == "miguel@gmail.com" && _passwordController.text == "123123") {
        // Se os dados estiverem corretos, valida e salva o userId
        validacao = true;
        userId = 1; // Coloque o userId correspondente ao login de "miguel@gmail.com"
      } else {
        // Caso contrário, consulta a API
        await consultaApiSenha();
      }

      if (validacao) {
        // Salva os dados de login no SharedPreferences (somente userId)
        await salvarDados(userId);

        // Redireciona para a tela principal (MyApp) sem o codAtributos
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(userId: userId),
          ),
        );
      } else {
        showCustomSnackBar(context, "E-mail ou senha incorretos!");
      }
    }
  }

  // Função para consultar a API e validar o login
  Future<void> consultaApiSenha() async {
    String url = 'http://localhost:8080/alunos';
    http.Response response;

    try {
      response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        List<dynamic> retorno = json.decode(responseBody);

        bool encontrado = false;
        for (var usuario in retorno) {
          String emailApi = usuario['email'];
          String senhaApi = usuario['senha'];

          if (emailApi == _emailController.text && senhaApi.trim() == _passwordController.text.trim()) {
            validacao = true;
            userId = usuario['id'];

            encontrado = true;
            break;
          }
        }

        if (!encontrado) {
          validacao = false;
        }
      } else {
        validacao = false;
        showCustomSnackBar(context, "Erro na API!");
      }
    } catch (e) {
      validacao = false;
      showCustomSnackBar(context, "Erro ao conectar com a API!");
    }
  }

  void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Função para alternar a visibilidade da senha
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;  // Alterna entre mostrar e ocultar a senha
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10.0),
              Text('Bem vindo ao seu futuro', style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center),
              SizedBox(height: 5.0),
              Text('OnFit', style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold, color: Colors.blue), textAlign: TextAlign.center),
              SizedBox(height: 15.0),
              Container(
                width: MediaQuery.of(context).size.width * 0.85, 
                padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 32.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.zero, boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3)),
                ]),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text('Login de Usuário', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center),
                      ),
                      SizedBox(height: 25.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(hintText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Por favor, insira seu email';
                          String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value)) return 'Por favor, insira um e-mail válido';
                          return null;
                        },
                      ),
                      SizedBox(height: 25.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                            onPressed: _togglePasswordVisibility, // Chama a função para alternar a visibilidade da senha
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Por favor, insira sua senha';
                          return null;
                        },
                      ),
                      SizedBox(height: 30.0),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: EdgeInsets.symmetric(vertical: 20.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                        child: Text('Entrar', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
