import 'package:flutter/material.dart';

class GuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guia de Medição'),
      ),
      body: SingleChildScrollView( // Permite rolagem
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Como medir corretamente as circunferências:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '1. **Cintura**: Meça a circunferência ao redor da parte mais estreita da sua cintura, geralmente logo acima do umbigo.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            // Alargando a imagem da cintura
            Image.asset(
              'assets/images/cintura.png', // Caminho correto da imagem
              width: double.infinity, // Largura máxima da tela
              height: 200,
              fit: BoxFit.cover, // Ajusta a imagem para cobrir todo o espaço
            ),
            SizedBox(height: 20),
            Text(
              '2. **Quadril**: Meça a circunferência ao redor da parte mais larga dos seus quadris.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            // Alargando a imagem do quadril
            Image.asset(
              'assets/images/quadril.png', // Caminho correto da imagem
              width: double.infinity, // Largura máxima da tela
              height: 200,
              fit: BoxFit.cover, // Ajusta a imagem para cobrir todo o espaço
            ),
            SizedBox(height: 20),
            Text(
              '3. **Pescoço**: Meça a circunferência ao redor da base do seu pescoço, logo abaixo do pomo de Adão (gogó).',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            // Alargando a imagem do pescoço
            Image.asset(
              'assets/images/pescoco.png', // Caminho correto da imagem
              width: double.infinity, // Largura máxima da tela
              height: 200,
              fit: BoxFit.cover, // Ajusta a imagem para cobrir todo o espaço
            ),
          ],
        ),
      ),
    );
  }
}
