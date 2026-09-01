import 'package:flutter/material.dart';

/// Aula 06 - Ícones e Navegação
///
/// Conteúdo:
/// - Widget [Icon] (tamanhos, cores e ícones do Material Design)
/// - Navegação imperativa com [Navigator.push] e [Navigator.pop]
/// - Navegação nomeada com [Navigator.pushNamed]
///
/// Projeto: Fluxo de navegação (Menu -> Perfil -> Configurações)
class Aula06 extends StatelessWidget {
  const Aula06({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aula 06 - Ícones e Navegação'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =========================================================
            // 1. SEÇÃO DE EXPOSIÇÃO DO WIDGET ICON
            // =========================================================
            const Text(
              '1. Utilizando Ícones (Icon)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'O widget Icon permite utilizar ícones do Material Icons alterando tamanho e cor:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.home, size: 36, color: Colors.indigo),
                    SizedBox(height: 4),
                    Text('Icons.home', style: TextStyle(fontSize: 11)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.person, size: 48, color: Colors.blue),
                    SizedBox(height: 4),
                    Text('Icons.person', style: TextStyle(fontSize: 11)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.settings, size: 36, color: Colors.amber),
                    SizedBox(height: 4),
                    Text('Icons.settings', style: TextStyle(fontSize: 11)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.star, size: 48, color: Colors.orange),
                    SizedBox(height: 4),
                    Text('Icons.star', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 28),

            // =========================================================
            // 2. SEÇÃO DE NAVEGAÇÃO ENTRE TELAS (FLUXO)
            // =========================================================
            const Text(
              '2. Navegação (Navigator)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'O Navigator gerencia uma pilha de telas (routes). Clique nos botões abaixo para navegar:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Card interativo do fluxo de telas
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.map,
                      size: 60,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Fluxo: Menu -> Perfil -> Configurações',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Botão 1: Ir para Perfil via Navigator.pushNamed com passagem de parâmetros
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      onPressed: () {
                        // Navegação nomeada enviando um parâmetro (argumento)
                        Navigator.pushNamed(
                          context,
                          '/aula06/perfil',
                          arguments: 'Ash Ketchum',
                        );
                      },
                      icon: const Icon(Icons.person),
                      label: const Text('Ir para Perfil (Passando Parâmetro)'),
                    ),

                    const SizedBox(height: 12),

                    // Botão 2: Ir direto para Configurações via Navigator.pushNamed
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.indigo,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/aula06/configuracoes');
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Ir para Configurações'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
