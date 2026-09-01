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
        padding: const EdgeInsets.all(20),
        child: Column(
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
            const SizedBox(height: 20),
            const Text(
              "Leonardo Candido",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Professor de Desenvolvimento",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                // Cada Expanded ocupa o mesmo espaço disponível na linha
                Expanded(
                  child: _infoCard(
                    Icons.school,
                    "Turmas",
                    "5",
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _infoCard(
                    Icons.code,
                    "Projetos",
                    "12",
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: _infoCard(
                    Icons.star,
                    "Nível",
                    "10",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _infoCard(
                    Icons.favorite,
                    "Likes",
                    "999",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Sobre Mim",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Professor apaixonado por tecnologia, programação "
              "e desenvolvimento de sistemas. "
              "Esta descrição foi adicionada para demonstrar o "
              "funcionamento do SingleChildScrollView quando "
              "o conteúdo da tela ultrapassa a altura do dispositivo.",
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    IconData icon,
    String titulo,
    String valor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.indigo,
          ),
          const SizedBox(height: 10),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(titulo),
        ],
      ),
    );
  }
}
