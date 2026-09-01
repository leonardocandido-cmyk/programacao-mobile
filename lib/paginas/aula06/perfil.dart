import 'package:flutter/material.dart';

/// Tela de Perfil da Aula 06
///
/// Demonstrando a navegação encadeada e retorno de tela com [Navigator.pop]
class Aula06Perfil extends StatelessWidget {
  const Aula06Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    // Recebendo o parâmetro enviado pela navegação (arguments)
    final String nomeUsuario =
        (ModalRoute.of(context)?.settings.arguments as String?) ??
            'Treinador Flutter';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              nomeUsuario,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Parâmetro recebido via Navigator',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const Spacer(),

            // Avançar para Configurações (Fluxo: Menu -> Perfil -> Configurações)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade800,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/aula06/configuracoes');
              },
              icon: const Icon(Icons.settings),
              label: const Text('Avançar para Configurações'),
            ),

            const SizedBox(height: 12),

            // Voltar para a tela anterior com Navigator.pop
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar (Navigator.pop)'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
