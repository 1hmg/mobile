import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Adicionando o SharedPreferences
import 'GuiaMedidas.dart'; // Certifique-se de que está no caminho correto
import 'ResultadoBF.dart'; // Importando a tela de resultados

class BodyFatScreen extends StatefulWidget {
  final int userId; // Parâmetro para o ID do usuário
  final String goal; // Parâmetro para o objetivo do usuário

  // Construtor para receber userId e goal
  BodyFatScreen({required this.userId, required this.goal});

  @override
  _BodyFatScreenState createState() => _BodyFatScreenState();
}

class _BodyFatScreenState extends State<BodyFatScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _waistCircumference; // Armazena a circunferência da cintura
  String? _hipCircumference; // Armazena a circunferência do quadril
  String? _neckCircumference; // Armazena a circunferência do pescoço

  int? userId; // Variável para armazenar o userId
  String? goal; // Variável para armazenar o goal

  // Função para carregar os dados do SharedPreferences
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId'); // Carregar userId
      goal = prefs.getString('goal'); // Carregar goal
    });
  }

  // Função para calcular o percentual de gordura corporal
  double calculateBodyFat({
    required double waistCircumference,
    required double hipCircumference,
    required double neckCircumference,
  }) {
    // Exemplo básico de cálculo, você pode substituir por um algoritmo mais adequado
    return (waistCircumference + hipCircumference - neckCircumference) / 2;
  }

  @override
  void initState() {
    super.initState();
    loadUserData(); // Carregar os dados do SharedPreferences quando a tela for carregada
  }

  @override
  Widget build(BuildContext context) {
    // Verificar se os dados estão carregados
    if (userId == null || goal == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Gordura Corporal'),
        ),
        body: Center(child: CircularProgressIndicator()), // Aguarda o carregamento
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Gordura Corporal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Barras de progresso com todas preenchidas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProgressBar(isFilled: true),
                SizedBox(width: 6),
                _buildProgressBar(isFilled: true),
                SizedBox(width: 6),
                _buildProgressBar(isFilled: true),
                SizedBox(width: 6),
                _buildProgressBar(isFilled: true),
                SizedBox(width: 6),
                _buildProgressBar(isFilled: true),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Para entendermos sobre sua real situação, necessitamos também da sua Gordura Corporal, preencha os dados:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Circunferência da cintura (cm)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a circunferência da cintura';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _waistCircumference = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Circunferência do quadril (cm)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a circunferência do quadril';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _hipCircumference = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Circunferência do pescoço (cm)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a circunferência do pescoço';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _neckCircumference = value;
                      },
                    ),
                    SizedBox(height: 40), // Aumentando o espaço acima do botão
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          // Calcula o percentual de gordura corporal
                          double bodyFatPercentage = calculateBodyFat(
                            waistCircumference: double.parse(_waistCircumference!),
                            hipCircumference: double.parse(_hipCircumference!),
                            neckCircumference: double.parse(_neckCircumference!),
                          );

                          // Navega para a tela de resultados, passando os parâmetros necessários
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BodyFatResultScreen(
                                bodyFatPercentage: bodyFatPercentage,
                                userId: userId!, // Passe o userId aqui
                                goal: goal!, // Passe o goal aqui
                                waistCircumference: double.parse(_waistCircumference!), // Passe a circunferência da cintura
                                hipCircumference: double.parse(_hipCircumference!), // Passe a circunferência do quadril
                                neckCircumference: double.parse(_neckCircumference!), // Passe a circunferência do pescoço
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
                        'Salvar Dados',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Frase e botão "Guia rápido"
            SizedBox(height: 20),
            Text(
              'Caso precise de ajuda, clique aqui:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30), // Aumentando o espaçamento entre a frase e o botão
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela GuideScreen ao clicar no botão 'Guia rápido'
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuideScreen(), // Chama a tela de guia
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Guia rápido',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Constrói as barras de progresso
  Widget _buildProgressBar({required bool isFilled}) {
    return Container(
      width: 60, // largura consistente com as outras telas
      height: 10, // altura consistente com as outras telas
      decoration: BoxDecoration(
        color: isFilled ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
