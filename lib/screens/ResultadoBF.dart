import 'package:flutter/material.dart';
import 'package:menu_teste2/screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Certifique-se de que o nome do arquivo está correto

class BodyFatResultScreen extends StatelessWidget {
  final double bodyFatPercentage; // Parâmetro para o percentual de gordura corporal
  final int userId;  // Parâmetro para o ID do usuário
  final String goal;  // Parâmetro para o objetivo do usuário
  final double waistCircumference;  // Parâmetro para a circunferência da cintura
  final double hipCircumference;   // Parâmetro para a circunferência do quadril
  final double neckCircumference;  // Parâmetro para a circunferência do pescoço

  BodyFatResultScreen({
    required this.bodyFatPercentage,
    required this.userId,
    required this.goal,
    required this.waistCircumference,
    required this.hipCircumference,
    required this.neckCircumference,
  }); // Construtor atualizado para receber os valores

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado da Gordura Corporal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Seu percentual de gordura corporal é:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${bodyFatPercentage.toStringAsFixed(2)}%', // Exibe o percentual com 2 casas decimais
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Classificação:',
              style: TextStyle(fontSize: 24),
            ),
            
            // Widget para exibir a classificação com a cor adequada
            _buildClassificationText(bodyFatPercentage),

            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Salvar os dados no SharedPreferences antes de navegar
                _saveDataToSharedPreferences();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Concluir Questionário'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para determinar a classificação baseada no percentual de gordura
  Widget _buildClassificationText(double percentage) {
    String classification;
    Color classificationColor;

    if (percentage < 6) {
      classification = "Você está abaixo do percentual de gordura saudável.";
      classificationColor = Colors.red; // Cor para abaixo do saudável
    } else if (percentage >= 6 && percentage <= 24) {
      classification = "Você está dentro da faixa saudável.";
      classificationColor = Colors.green; // Cor para faixa saudável
    } else {
      classification = "Você está acima do percentual de gordura saudável.";
      classificationColor = Colors.orange; // Cor para acima do saudável
    }

    return Text(
      classification,
      style: TextStyle(fontSize: 20, color: classificationColor), // Usa a cor definida
      textAlign: TextAlign.center,
    );
  }

  // Função para salvar os dados no SharedPreferences
  Future<void> _saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setString('goal', goal);
    await prefs.setDouble('waistCircumference', waistCircumference);
    await prefs.setDouble('hipCircumference', hipCircumference);
    await prefs.setDouble('neckCircumference', neckCircumference);
  }
}
