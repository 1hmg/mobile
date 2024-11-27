import 'package:flutter/material.dart';
import 'package:menu_teste2/screens/MedidasBF.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importando o SharedPreferences

class ResultScreen extends StatelessWidget {
  final double? weight; // Peso
  final double? height; // Altura
  final int? age; // Idade
  final String? gender; // Gênero
  final int? userId; // ID do usuário
  final String? goal; // Objetivo do usuário

  // Construtor da tela ResultScreen, agora recebendo userId e goal
  ResultScreen({
    this.weight,
    this.height,
    this.age,
    this.gender,
    this.userId,
    this.goal,
  });

  @override
  Widget build(BuildContext context) {
    // Verificar se os dados são válidos
    if (weight == null || height == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Erro'),
        ),
        body: Center(
          child: Text('Dados inválidos.'),
        ),
      );
    }

    double imc = weight! / ((height! / 100) * (height! / 100));

    String classification;
    Color color;

    if (imc < 18.5) {
      classification = "Abaixo do peso";
      color = Colors.blue;
    } else if (imc < 24.9) {
      classification = "Peso normal";
      color = Colors.green;
    } else if (imc < 29.9) {
      classification = "Sobrepeso";
      color = Colors.yellow;
    } else {
      classification = "Obesidade";
      color = Colors.red;
    }

    // Salva os dados no SharedPreferences
    _saveDataToSharedPreferences();

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado do IMC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Alinhado para cima
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Seu IMC é: ${imc.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              'Você está classificado como:',
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              classification,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            _buildIMCProgressBar(imc, context),
            SizedBox(height: 25),
            _buildIMCInfo(),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                // Verificar se os dados são válidos antes de navegar
                if (userId != null && goal != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BodyFatScreen(
                        userId: userId!, // Passando userId para a próxima tela
                        goal: goal!, // Passando goal para a próxima tela
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Dados de usuário ou objetivo inválidos.')),
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', weight!);  
    await prefs.setDouble('height', height!);  
    await prefs.setInt('age', age!);           
    await prefs.setString('gender', gender!);  
  }

  Widget _buildIMCProgressBar(double imc, BuildContext context) {
    double normalizedIMC = (imc - 10) / 40; // Normalizando o IMC para a barra
    normalizedIMC = normalizedIMC.clamp(0.0, 1.0); // Garantir que o valor esteja entre 0 e 1

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 30,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.red],
              stops: [0.1, 0.25, 0.5, 0.75, 1],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: Alignment(normalizedIMC - 1, 0),
            child: Container(
              width: 5,
              height: 40,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildIMCInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Abaixo de 18.5: Abaixo do peso', style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text('18.5 - 24.9: Peso normal', style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text('25 - 29.9: Sobrepeso', style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text('Acima de 30: Obesidade', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}
