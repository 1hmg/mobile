import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final int userId;
  final Map<String, String> currentProfileData;

  EditProfilePage({required this.userId, required this.currentProfileData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _ageController;
  late TextEditingController _neckController;
  late TextEditingController _waistController;
  late TextEditingController _hipController;
  String _selectedSex = 'M'; // Variável para armazenar o sexo selecionado
  String _selectedExercicio = 'Sedentario'; // Variável para armazenar o exercício selecionado
  String _selectedIntencao = 'Ganhar Massa Muscular'; // Variável para armazenar a intenção selecionada

  @override
  void initState() {
    super.initState();

    // Inicializa os controladores com os valores passados
    _weightController = TextEditingController(text: widget.currentProfileData['peso']);
    _heightController = TextEditingController(text: widget.currentProfileData['altura']);
    _ageController = TextEditingController(text: widget.currentProfileData['idade']);
    _neckController = TextEditingController(text: widget.currentProfileData['pescoco']);
    _waistController = TextEditingController(text: widget.currentProfileData['cintura']);
    _hipController = TextEditingController(text: widget.currentProfileData['quadril']);
    
    // Inicializa as variáveis com os valores atuais para sexo, exercício e intenção
    _selectedSex = widget.currentProfileData['sexo'] == 'M' ? 'Masculino' : 'Feminino';
    _selectedExercicio = widget.currentProfileData['exercicio'] ?? 'Sedentario';
    _selectedIntencao = widget.currentProfileData['intencao'] ?? 'Ganhar Massa Muscular';
  }

  @override
  void dispose() {
    // Libera os controladores quando a página for descartada
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _neckController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    super.dispose();
  }

  // Função para atualizar o perfil na API
  Future<void> updateProfile(int userId, Map<String, String> updatedData) async {
  // Substitua localhost pelo IP da máquina onde o servidor API está rodando
  final url = 'http://localhost:8080/atributos/$userId'; // URL da sua API

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedData),
    );

    if (response.statusCode == 200) {
      // Verifique o corpo da resposta
      print('Perfil atualizado com sucesso!');
      print('Resposta: ${response.body}');
    } else {
      // Exiba a resposta para entender o erro
      print('Falha ao atualizar perfil: ${response.statusCode}');
      print('Resposta: ${response.body}');
      throw Exception('Falha ao atualizar perfil');
    }
  } catch (e) {
    print('Erro ao tentar conectar com a API: $e');
    throw Exception('Erro ao tentar conectar com a API: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('Peso (kg)', _weightController),
            _buildTextField('Altura (cm)', _heightController),
            _buildTextField('Idade (anos)', _ageController),
            _buildTextField('Pescoço (cm)', _neckController),
            _buildTextField('Cintura (cm)', _waistController),
            _buildTextField('Quadril (cm)', _hipController),
            _buildSexDropdown(), // Campo para escolher Sexo
            _buildExercicioDropdown(), // Campo para escolher Exercício
            _buildIntencaoDropdown(), // Campo para escolher Intenção
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Dados atualizados
                Map<String, String> updatedData = {
                  'peso': _weightController.text,
                  'altura': _heightController.text,
                  'idade': _ageController.text,
                  'pescoco': _neckController.text,
                  'cintura': _waistController.text,
                  'quadril': _hipController.text,
                  'sexo': _selectedSex == 'Masculino' ? 'M' : 'F', // Converte para 'M' ou 'F'
                  'exercicio': _selectedExercicio,
                  'intencao': _selectedIntencao,
                };

                try {
                  // Atualiza o perfil na API
                  await updateProfile(widget.userId, updatedData);

                  // Quando a atualização for bem-sucedida, navegue de volta
                  Navigator.pop(context, updatedData);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erro ao atualizar perfil: $e")),
                  );
                }
              },
              child: Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  // Função para o campo de sexo
  Widget _buildSexDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButton<String>(
        value: _selectedSex == 'M' ? 'Masculino' : 'Feminino', // Exibe o nome completo
        onChanged: (String? newValue) {
          setState(() {
            _selectedSex = newValue == 'Masculino' ? 'M' : 'F'; // Converte para 'M' ou 'F'
          });
        },
        items: <String>['Masculino', 'Feminino']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  // Função para o campo de exercício
  Widget _buildExercicioDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButton<String>(
        value: _selectedExercicio, // Exibe o valor atual de exercício
        onChanged: (String? newValue) {
          setState(() {
            _selectedExercicio = newValue!; // Atualiza o valor do exercício
          });
        },
        items: <String>[
          'Sedentario', 
          'Levemente Ativo', 
          'Moderadamente Ativo', 
          'Muito Ativo', 
          'Extremamente Ativo'
        ]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  // Função para o campo de intenção
  Widget _buildIntencaoDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButton<String>(
        value: _selectedIntencao, // Exibe o valor atual de intenção
        onChanged: (String? newValue) {
          setState(() {
            _selectedIntencao = newValue!; // Atualiza o valor da intenção
          });
        },
        items: <String>[
          'Ganhar Massa Muscular', 
          'Manter Peso', 
          'Perder Peso'
        ]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
