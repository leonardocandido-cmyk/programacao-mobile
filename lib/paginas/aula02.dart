import 'package:flutter/material.dart';

class Aula02 extends StatelessWidget {
  const Aula02({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("02 - Linhas e colunas"),
      ),
      body: const Center(
        child: Text("Linhas e colunas"),
      ),
    );
  }
}
