import 'package:flutter/material.dart';
import 'package:menu_teste2/screens/ResultadoIMC.dart'; // Certifique-se de que essa tela está importada
import 'package:shared_preferences/shared_preferences.dart';

class WeightHeightScreen extends StatefulWidget {
  final int userId; // Torne o userId final
  final String goal; // Torne o goal final

  // Construtor para receber dados da tela anterior
  WeightHeightScreen({
    required this.userId,
    required this.goal,
  });

  @override
  _WeightHeightScreenState createState() => _WeightHeightScreenState();
}

class _WeightHeightScreenState extends State<WeightHeightScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _weight; // Armazena o peso
  String? _height; // Armazena a altura
  String? _gender; // Armazena o gênero
  int? _age; // Armazena a idade
  List<String> _genders = ['Masculino', 'Feminino']; // Gêneros disponíveis
  TextEditingController _contraIndicationsController = TextEditingController(); // Controlador para as contraindicações

  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
  }

  // Carrega os dados de SharedPreferences (userId, goal)
  Future<void> _loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Carregar outros dados se necessário
      _weight = prefs.getString('weight');
      _height = prefs.getString('height');
      _age = prefs.getInt('age');
      _gender = prefs.getString('gender');
      _contraIndicationsController.text = prefs.getString('contraIndications') ?? '';
    });
  }

  // Método para salvar os dados no SharedPreferences
  Future<void> _saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', widget.userId); // Armazenando o userId
    await prefs.setString('goal', widget.goal); // Armazenando o goal
    await prefs.setString('weight', _weight ?? ''); // Armazenando o peso
    await prefs.setString('height', _height ?? ''); // Armazenando a altura
    await prefs.setInt('age', _age ?? 0); // Armazenando a idade
    await prefs.setString('gender', _gender ?? ''); // Armazenando o gênero
    await prefs.setString('contraIndications', _contraIndicationsController.text); // Armazenando as contraindicações
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Características'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Formulário de dados
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Campo de peso
                  TextFormField(
                    initialValue: _weight, // Preenche com valor salvo
                    decoration: InputDecoration(
                      labelText: 'Peso (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu peso';
                      }
                      if (double.tryParse(value)! <= 0) {
                        return 'Peso não pode ser 0 ou negativo';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _weight = value;
                    },
                  ),
                  SizedBox(height: 20),
                  // Campo de altura
                  TextFormField(
                    initialValue: _height, // Preenche com valor salvo
                    decoration: InputDecoration(
                      labelText: 'Altura (cm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua altura';
                      }
                      if (int.tryParse(value)! <= 0) {
                        return 'Altura não pode ser 0 ou negativa';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _height = value;
                    },
                  ),
                  SizedBox(height: 20),
                  // Campo de idade
                  TextFormField(
                    initialValue: _age != null ? _age.toString() : '', // Preenche com valor salvo
                    decoration: InputDecoration(
                      labelText: 'Idade',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua idade';
                      }
                      if (int.tryParse(value)! <= 0 || int.tryParse(value)! > 120) {
                        return 'Idade inválida';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _age = int.tryParse(value!);
                    },
                  ),
                  SizedBox(height: 20),
                  // Dropdown de gênero
                  DropdownButtonFormField<String>(
                    value: _gender, // Preenche com valor salvo
                    decoration: InputDecoration(
                      labelText: 'Gênero',
                      border: OutlineInputBorder(),
                    ),
                    items: _genders.map((String gender) {
                      return DropdownMenuItem<String>( 
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione seu gênero';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Campo de contraindicações
                  TextFormField(
                    controller: _contraIndicationsController,
                    decoration: InputDecoration(
                      labelText: 'Contraindicações',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 60),
                  // Botão "Avançar"
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Salva os dados no SharedPreferences
                        await _saveDataToSharedPreferences();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              userId: widget.userId,
                              goal: widget.goal,
                              weight: double.parse(_weight!),
                              height: double.parse(_height!),
                              age: _age!,
                              gender: _gender!,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Avançar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
