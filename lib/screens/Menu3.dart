import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DietPage extends StatefulWidget {
  final int userId; // Alterado para refletir "cod_usuario" do banco

  DietPage({required this.userId});

  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  TextEditingController _atualizarDietaController = TextEditingController();

  double? _caloriasNecessarias;
  String? _erro;

  // Dados do usuário (simulados, normalmente buscados da API)
  double? _peso;
  double? _altura;
  int? _idade;
  String? _sexo;
  String? _exercicio;
  String? _dietaMontada; // Variável para armazenar a dieta montada

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Busca os dados do usuário ao inicializar
    _loadDietaMontada(); // Carrega a dieta montada
  }

  Future<void> _loadUserData() async {
    final String url = 'http://localhost:8080/atributos/${widget.userId}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _peso = data['peso'];
          _altura = data['altura']; // Assumindo que já está em cm
          _idade = data['idade'];
          _sexo = data['sexo'];
          _exercicio = data['exercicio'];
        });

        _calcularCalorias(); // Calcula as calorias após carregar os dados
      } else {
        print('Erro ao carregar dados do usuário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar dados: $e');
    }
  }

  Future<void> _loadDietaMontada() async {
    final String url = 'http://localhost:8080/dieta/${widget.userId}'; // Ajustado para pegar a dieta do usuário específico

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _dietaMontada = data['dietaMontada']; // Atribui a dieta montada
        });
      } else {
        print('Erro ao carregar dieta montada: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar dieta montada: $e');
    }
  }

  void _calcularCalorias() {
    if (_peso != null && _altura != null && _idade != null && _sexo != null) {
      double tmb;

      if (_sexo == 'M') {
        tmb = 88.36 + (13.4 * _peso!) + (4.8 * _altura!) - (5.7 * _idade!);
      } else {
        tmb = 447.6 + (9.2 * _peso!) + (3.1 * _altura!) - (4.3 * _idade!);
      }

      double fatorAtividade = _getFatorAtividade(_exercicio ?? 'Sedentario');
      double calorias = tmb * fatorAtividade;

      setState(() {
        _caloriasNecessarias = calorias;
        _erro = null;
      });

      _updateCaloriasNecessarias(); // Atualiza o valor no banco de dados
    } else {
      setState(() {
        _erro = 'Dados insuficientes para o cálculo.';
      });
    }
  }

  double _getFatorAtividade(String exercicio) {
    switch (exercicio) {
      case 'Sedentario':
        return 1.2;
      case 'Levemente Ativo':
        return 1.375;
      case 'Moderadamente Ativo':
        return 1.55;
      case 'Muito Ativo':
        return 1.725;
      case 'Extremamente Ativo':
        return 1.9;
      default:
        return 1.2; // Valor padrão para evitar erros
    }
  }

  Future<void> _updateCaloriasNecessarias() async {
    if (_caloriasNecessarias != null) {
      final String url = 'http://localhost:8080/dieta/${widget.userId}'; // Endpoint para atualizar os dados

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'caloriasNecessarias': _caloriasNecessarias, // Envia a necessidade calórica calculada
        }),
      );

      if (response.statusCode == 200) {
        print('Dados atualizados com sucesso');
      } else {
        print('Falha ao atualizar dados: ${response.statusCode}');
      }
    }
  }

  Future<void> enviarAtualizacaoDieta() async {
  if (_atualizarDietaController.text.isEmpty) {
    // Validação: Exibe uma mensagem de erro se a caixa de texto estiver vazia
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor, insira algo para atualizar a dieta.')),
    );
    return;
  }

  // Atualizar dieta no banco de dados
  final String atualizarDietaUrl = 'http://localhost:8080/dieta/${widget.userId}';

  try {
    final atualizarDietaResponse = await http.put(
      Uri.parse(atualizarDietaUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'complementacoes': _atualizarDietaController.text,
      }),
    );

    if (atualizarDietaResponse.statusCode == 200) {
      // Atualizar dieta_status no banco de dados
      final String atualizarStatusUrl = 'http://localhost:8080/dieta/${widget.userId}';

      final atualizarStatusResponse = await http.put(
        Uri.parse(atualizarStatusUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'dieta_status': 'atualizar dieta',
        }),
      );

      if (atualizarStatusResponse.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dieta atualizada e status alterado com sucesso!')),
        );
      } else {
        print('Erro ao alterar status: ${atualizarStatusResponse.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao alterar o status da dieta.')),
        );
      }
    } else {
      print('Erro ao atualizar dieta: ${atualizarDietaResponse.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao atualizar a dieta.')),
      );
    }
  } catch (e) {
    print('Erro ao fazer requisição: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro de conexão. Tente novamente mais tarde.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Dietas"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Necessidade Calórica Diária',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              if (_caloriasNecessarias != null)
                Text(
                  '${_caloriasNecessarias!.toStringAsFixed(2)} kcal/dia',
                  style: TextStyle(fontSize: 40),
                )
              else if (_erro != null)
                Text(
                  _erro!,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              SizedBox(height: 20),
              Text(
                'Dieta Montada:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Text(
                  _dietaMontada ?? 'A dieta montada não está disponível.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Atualizar Dieta:',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                controller: _atualizarDietaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite a atualização para a dieta...',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: enviarAtualizacaoDieta,
                  child: Text('Enviar Atualização'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
