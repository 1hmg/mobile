import 'package:flutter/material.dart';

class ProtocolPage extends StatelessWidget {
  const ProtocolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Faixa azul no topo com a seta e o título "Seu Protocolo" alinhados mais à direita
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                const SizedBox(width: 16), // Espaçamento extra à esquerda
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 20), // Espaçamento entre seta e título
                Expanded(
                  child: Text(
                    "Seu Protocolo",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24, // Fonte aumentada
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Retângulo fino com bordas arredondadas e mensagem de atenção centralizada
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Text(
                    "Atenção: nossas dietas são produzidas por um time de profissionais habilitados e credenciados",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                // Caixa de diálogo simulando uma mensagem recebida
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    margin: const EdgeInsets.only(right: 50),
                    decoration: BoxDecoration(
                      color: Colors.blue[800], // Alterado para azul
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomRight: const Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Esta é uma mensagem de exemplo recebida da API. Depois podemos exibir aqui a resposta real do profissional.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}