import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PesoAltura.dart'; // Certifique-se de que a próxima tela está importada corretamente

class HealthScreen extends StatefulWidget {
  final int userId;
  final String goal;

  // Construtor para receber os parâmetros
  HealthScreen({
    required this.userId,
    required this.goal,
  });

  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final TextEditingController _contraIndicationsController = TextEditingController();

  @override
  void dispose() {
    _contraIndicationsController.dispose();
    super.dispose();
  }

  // Método para salvar dados no SharedPreferences
  Future<void> _saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', widget.userId); // Armazenando o userId
    await prefs.setString('goal', widget.goal);   // Armazenando o goal
    // Não estamos armazenando `activityLevel` ou `contraIndications` aqui
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saúde e Contraindicações'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Barras de progresso estilo stories
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProgressBar(isFilled: true),
                  SizedBox(width: 6),
                  _buildProgressBar(isFilled: true),
                  SizedBox(width: 6),
                  _buildProgressBar(isFilled: true),
                  SizedBox(width: 6),
                  _buildProgressBar(isFilled: false),
                  SizedBox(width: 6),
                  _buildProgressBar(isFilled: false),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Nos preocupamos também com o seu bem-estar. Para uma dieta personalizada, conte-nos sobre suas contraindicações caso houver, como alergias e doenças.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              _buildContraIndicationsBox(),
              SizedBox(height: 80),

              // Botão de navegação
              ElevatedButton(
                onPressed: () async {
                  // Chama o método para salvar os dados no SharedPreferences
                  await _saveDataToSharedPreferences();

                  // Navegação para a próxima tela com apenas id e goal
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeightHeightScreen(
                        userId: widget.userId,
                        goal: widget.goal,
                      ),
                    ),
                  );
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
      ),
    );
  }

  // Constrói cada barra de progresso
  Widget _buildProgressBar({required bool isFilled}) {
    return Container(
      width: 60, // Consistente entre as telas
      height: 10,
      decoration: BoxDecoration(
        color: isFilled ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  // Caixa de contraindicações
  Widget _buildContraIndicationsBox() {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 200, // Aumenta a altura verticalmente
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _contraIndicationsController,
        maxLines: null, // Permite o crescimento automático se o usuário digitar muito texto
        decoration: InputDecoration(
          hintText: 'Digite aqui', // Exibe apenas "Digite aqui"
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0), // Ajusta o padding vertical
        ),
      ),
    );
  }
}
