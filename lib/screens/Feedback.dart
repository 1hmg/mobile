import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Faixa azul no topo com a seta e o título "Feedback"
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
                    "Feedback",
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
                // Caixa de aviso com bordas arredondadas e mensagem centralizada
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Text(
                    "Seu feedback é de extrema importância para melhorarmos sua dieta baseado no que é melhor para você.",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                    textAlign: TextAlign.center, // Centraliza a mensagem
                  ),
                ),
                const SizedBox(height: 20), // Espaço entre a caixa de aviso e a caixa de diálogo
                // Caixa retangular para o usuário escrever o feedback
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Cor de fundo da caixa
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    maxLines: 8, // Permite múltiplas linhas de texto
                    decoration: const InputDecoration(
                      hintText: "Escreva seu feedback aqui...",
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(), // Empurra os elementos seguintes para baixo
          Padding(
            padding: const EdgeInsets.only(bottom: 30), // Ajusta a posição do botão mais para baixo
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5, // Reduz a largura do botão pela metade
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feedback enviado com sucesso!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Cor azul do botão
                    padding: const EdgeInsets.symmetric(vertical: 16), // Tamanho vertical ajustado
                  ),
                  child: const Text(
                    'Enviar feedback',
                    style: TextStyle(
                      color: Colors.white, // Texto branco
                      fontSize: 18, // Tamanho do texto
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
