import 'package:flutter/material.dart';
import 'tabuleiro.dart';

class TelaInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CodeBest Quest',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, 
          ),
        ),
        backgroundColor: Color(0xFF5E2A8C), 
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF4B1F72), 
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bem-vindo ao Caça-palavras de Programação!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white, 
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Espaçamento entre as seções
            Text(
              'Encontre todas as palavras escondidas no tabuleiro. Toque nas letras para selecionar a palavra e clique em "Marcar Palavra" para confirmar!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70, 
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30), // Espaçamento antes do botão
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Tabuleiro()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7A4E9E), 
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5, // Elevação para dar mais destaque
              ),
              child: Text(
                'Iniciar Jogo',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 30), // Espaçamento antes da imagem
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/Android.png',
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
