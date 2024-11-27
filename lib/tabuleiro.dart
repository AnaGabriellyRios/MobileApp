import 'dart:math';
import 'package:flutter/material.dart';
import 'tela_fim.dart';

class Tabuleiro extends StatefulWidget {
  @override
  _TabuleiroState createState() => _TabuleiroState();
}

class _TabuleiroState extends State<Tabuleiro> {
  final int tamanho = 8;
  final List<String> todasPalavras = [
    "DART",
    "CODE",
    "DEBUG",
    "LOOP",
    "FLUTTER",
    "OBJECT",
    "CLASS",
    "VOID",
    "ARRAY",
    "STRING",
    "DOUBLE",
    "LIST",
    "SUPER",
    "IF",
    "FOR",
    "INTEIRO",
    "RETURN",
    "FINAL"
  ];

  List<List<String>> tabuleiro = [];
  List<List<bool>> letrasGrifadas = [];
  List<List<bool>> letrasSelecionadas = [];
  List<String> palavras = [];
  List<String> palavrasEncontradas = [];
  int score = 0;
  String palavraAtual = '';
  List<Offset> caminhoAtual = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _inicializarJogo();
  }

  void _inicializarJogo() {
    score = 0;
    palavrasEncontradas.clear();
    caminhoAtual.clear();
    palavraAtual = '';
    _selecionarPalavrasAleatorias();
    _gerarTabuleiroAleatorio();
    letrasGrifadas = List.generate(tamanho, (_) => List.filled(tamanho, false));
    letrasSelecionadas = List.generate(
        tamanho,
        (_) =>
            List.filled(tamanho, false)); // Inicializa as letras selecionadas
  }

  void _selecionarPalavrasAleatorias() {
    palavras = (todasPalavras.toList()..shuffle()).take(5).toList();
  }

  void _gerarTabuleiroAleatorio() {
    tabuleiro = List.generate(tamanho, (_) => List.filled(tamanho, ''));
    for (String palavra in palavras) {
      bool palavraColocada = false;
      while (!palavraColocada) {
        int linha = _random.nextInt(tamanho);
        int coluna = _random.nextInt(tamanho);
        List<int> direcao = _escolherDirecaoAleatoria();
        if (_cabeNoTabuleiro(palavra, linha, coluna, direcao)) {
          for (int i = 0; i < palavra.length; i++) {
            tabuleiro[linha + i * direcao[0]][coluna + i * direcao[1]] =
                palavra[i];
          }
          palavraColocada = true;
        }
      }
    }

    // Preencher o tabuleiro com letras aleatórias
    for (int i = 0; i < tamanho; i++) {
      for (int j = 0; j < tamanho; j++) {
        if (tabuleiro[i][j] == '') {
          tabuleiro[i][j] = String.fromCharCode(65 + _random.nextInt(26));
        }
      }
    }
  }

  List<int> _escolherDirecaoAleatoria() {
    List<List<int>> direcoes = [
      [0, 1],
      [1, 0],
      [1, 1],
      [-1, 1],
      [0, -1],
      [-1, 0],
      [-1, -1],
      [1, -1]
    ];
    return direcoes[_random.nextInt(direcoes.length)];
  }

  bool _cabeNoTabuleiro(
      String palavra, int linha, int coluna, List<int> direcao) {
    for (int i = 0; i < palavra.length; i++) {
      int novaLinha = linha + i * direcao[0];
      int novaColuna = coluna + i * direcao[1];
      if (novaLinha < 0 ||
          novaLinha >= tamanho ||
          novaColuna < 0 ||
          novaColuna >= tamanho ||
          (tabuleiro[novaLinha][novaColuna] != '' &&
              tabuleiro[novaLinha][novaColuna] != palavra[i])) {
        return false;
      }
    }
    return true;
  }

  // Ana Clara
  void selecionarCelula(int linha, int coluna) {
    setState(() {
      Offset posicao = Offset(linha.toDouble(), coluna.toDouble());
      if (caminhoAtual.isEmpty || _ehAdjacente(posicao, caminhoAtual.last)) {
        if (!caminhoAtual.contains(posicao)) {
          caminhoAtual.add(posicao);
          palavraAtual += tabuleiro[linha][coluna];
          letrasSelecionadas[linha][coluna] =
              true; // Marca a letra como selecionada
        }
      } else {
        _limparSelecao();
      }
    });
  }

  bool _ehAdjacente(Offset a, Offset b) {
    return (a.dx - b.dx).abs() <= 1 && (a.dy - b.dy).abs() <= 1;
  }

  void verificarPalavra() {
    if (palavras.contains(palavraAtual) &&
        !palavrasEncontradas.contains(palavraAtual)) {
      setState(() {
        palavrasEncontradas.add(palavraAtual);
        score += 10;

        for (Offset posicao in caminhoAtual) {
          int linha = posicao.dx.toInt();
          int coluna = posicao.dy.toInt();
          letrasGrifadas[linha][coluna] = true; // Marcar a letra como grifada
        }
      });

      // Verifique se todas as palavras foram encontradas
      if (palavrasEncontradas.length == palavras.length) {
        _mostrarTelaFim(); 
      }
    }
    _limparSelecao();
  }

  void _limparSelecao() {
    setState(() {
      caminhoAtual.clear();
      palavraAtual = '';
      letrasSelecionadas = List.generate(
          tamanho, (_) => List.filled(tamanho, false)); // Limpa a seleção
    });
  }

  void _mostrarTelaFim() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TelaFim(
          score: score,
          reiniciar: () {
            _inicializarJogo(); 
            Navigator.pop(context); 
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Boa Sorte!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ), 
        ),
        backgroundColor: Color(0xFF5E2A8C),
        actions: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Pontos: $score",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight:
                    FontWeight.bold, 
              ),
            ),
          ),
        ],
      ),
      body: Container(
      color: Color(0xFF4B1F72), 
        child: Column(
          children: [
            _PalavraLista(jogo: this),
            Expanded(child: _TabuleiroGrid(jogo: this)),
            ElevatedButton(
              onPressed: verificarPalavra,
              child: Text('Marcar Palavra',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7A4E9E),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                shadowColor: Colors.black45,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _PalavraLista extends StatelessWidget {
  final _TabuleiroState jogo;

  _PalavraLista({required this.jogo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8.0,
        children: jogo.palavras.map((palavra) {
          bool encontrado = jogo.palavrasEncontradas.contains(palavra);
          return Container(
            child: Chip(
              label: Text(
                palavra,
                style: TextStyle(
                  color: encontrado
                      ? Colors.white
                      : Colors.black, 
                ),
              ),
              backgroundColor: encontrado
                  ? const Color.fromARGB(255, 4, 18, 43)
                  : Colors.grey[300],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TabuleiroGrid extends StatelessWidget {
  final _TabuleiroState jogo;

  _TabuleiroGrid({required this.jogo});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: jogo.tamanho,
        childAspectRatio: 1.0,
      ),
      itemCount: jogo.tamanho * jogo.tamanho,
      itemBuilder: (context, index) {
        int linha = index ~/ jogo.tamanho;
        int coluna = index % jogo.tamanho;
        bool letraSelecionada = jogo.letrasSelecionadas[linha][coluna];
        bool letraGrifada = jogo.letrasGrifadas[linha][coluna];

        return GestureDetector(
          onTap: () => jogo.selecionarCelula(linha, coluna),
          child: Container(
            margin: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: letraSelecionada
                  ? Colors.blue[200]
                  : letraGrifada
                      ? Colors.green[200]
                      : Colors.white,
              border: Border.all(
                color: Colors.white, 
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                jogo.tabuleiro[linha][coluna],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: letraGrifada ? Colors.black : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
