import 'package:flutter/material.dart';
import 'tela_inicio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caça-palavras',
      home: TelaInicio(),
    );
  }
}
