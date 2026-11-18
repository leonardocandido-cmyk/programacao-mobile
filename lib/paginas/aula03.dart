import 'package:flutter/material.dart';

class Aula03 extends StatelessWidget {
  const Aula03({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _criarInfo({
      required IconData icone,
      required String titulo,
      required String texto,
    }) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            Icon(
              icone,
              size: 40,
              color: Colors.indigo,
            ),
            const SizedBox(height: 10),
            Text(
              texto,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(titulo),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Perfil"),
        // Centraliza o título da AppBar
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Adiciona um padding em torno do conteúdo da tela
        padding: EdgeInsets.all(20),
        // Precisamos do container para aplicar alinhamento de forma correta
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // Alinhando ao centro
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cria um avatar circular
              const CircleAvatar(
                radius: 65,
                backgroundColor: Colors.indigo,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 70,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Leonardo Roberto",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Professor",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              // Dispor elementos em linha
              Row(
                children: [
                  _criarInfo(icone: Icons.school, titulo: "Turmas", texto: "5"),
                  _criarInfo(icone: Icons.code, titulo: "Projetos", texto: "12"),
                  _criarInfo(icone: Icons.star, titulo: "Nível", texto: "10"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
