import 'package:flutter/material.dart';

class Aula03 extends StatelessWidget {
  const Aula03({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Perfil"),
        // Centraliza o título da AppBar
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Adiciona um padding em torno do conteúdo da tela
        padding: EdgeInsets.all(20),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
