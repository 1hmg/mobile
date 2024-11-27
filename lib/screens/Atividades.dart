import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importando o SharedPreferences
import 'Saude.dart'; // Certifique-se de importar o arquivo correto de HealthScreen

class ActivityLevelScreen extends StatefulWidget {
  final int userId;  // Parâmetro userId
  final String goal; // Parâmetro goal

  ActivityLevelScreen({required this.userId, required this.goal}); // Construtor para passar os dados

  @override
  _ActivityLevelScreenState createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  String? _selectedActivityLevel; // Armazena o nível de atividade selecionado

  // Função para armazenar o userId e goal no SharedPreferences
  Future<void> _saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', widget.userId); // Armazenando o userId
    await prefs.setString('goal', widget.goal);   // Armazenando o goal
    await prefs.setString('activityLevel', _selectedActivityLevel ?? ''); // Armazenando o nível de atividade
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nível de Atividade'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProgressBar(isFilled: true),
                  SizedBox(width: 6),
                  _buildProgressBar(isFilled: true),
                  SizedBox(width: 6),
                  _buildProgressBar(isFilled: false),
                  SizedBox(width: 6),
                  _buildProgressBar(isFilled: false),
                  SizedBox(width: 6),
                  _buildProgressBar(isFilled: false),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Escolha o nível de atividade para continuarmos',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildActivityOption('Sedentário'),
              SizedBox(height: 25),
              _buildActivityOption('Levemente Ativo'),
              SizedBox(height: 25),
              _buildActivityOption('Moderadamente Ativo'),
              SizedBox(height: 25),
              _buildActivityOption('Muito Ativo'),
              SizedBox(height: 25),
              _buildActivityOption('Extremamente Ativo'),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: _selectedActivityLevel != null
                    ? () async {
                        // Salvar os dados no SharedPreferences antes de navegar
                        await _saveDataToSharedPreferences();
                        // Passando userId e goal diretamente para a próxima tela
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HealthScreen(
                              userId: widget.userId,  // Passando o userId
                              goal: widget.goal,       // Passando o goal
                            ),
                          ),
                        );
                      }
                    : null, // Desabilita o botão se _selectedActivityLevel for nulo
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  backgroundColor: _selectedActivityLevel != null ? Colors.blue : Colors.grey,
                ),
                child: Text(
                  'Avançar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar({required bool isFilled}) {
    return Container(
      width: 60,
      height: 10,
      decoration: BoxDecoration(
        color: isFilled ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildActivityOption(String activityLevel) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedActivityLevel = activityLevel;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedActivityLevel == activityLevel ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.blue),
        ),
        child: Center(
          child: Text(
            activityLevel,
            style: TextStyle(
              color: _selectedActivityLevel == activityLevel ? Colors.white : Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
