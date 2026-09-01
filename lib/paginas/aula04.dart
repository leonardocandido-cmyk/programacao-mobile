import 'package:flutter/material.dart';

class Aula04 extends StatelessWidget {
  const Aula04({super.key});

  void explorarJogos() {
    print('Usuário escolheu explorar jogos!');
  }

  void categorias() {
    print('Usuário abriu as categorias!');
  }

  void promocoes() {
    print('Usuário abriu as promoções!');
  }

  void favoritos() {
    print('Usuário abriu os favoritos!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =========================
      // APP BAR
      // =========================

      appBar: AppBar(
        title: const Text(
          'Game Store',
        ),
        actions: [
          IconButton(
            onPressed: favoritos,
            icon: const Icon(
              Icons.favorite,
            ),
          ),
          IconButton(
            onPressed: () {
              print('Carrinho aberto!');
            },
            icon: const Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
      ),

      // =========================
      // CONTEÚDO
      // =========================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // =========================
            // TÍTULO
            // =========================

            const Text(
              'Encontre seu próximo jogo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Explore jogos, categorias e promoções.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // CARD DE DESTAQUE
            // =========================

            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_esports,
                    size: 70,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Jogos em destaque',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // ELEVATED BUTTON
            // =========================

            ElevatedButton(
              onPressed: explorarJogos,
              child: const Text(
                'Explorar jogos',
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // FILLED BUTTON
            // =========================

            FilledButton(
              onPressed: categorias,
              child: const Text(
                'Categorias',
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // OUTLINED BUTTON
            // =========================

            OutlinedButton(
              onPressed: promocoes,
              child: const Text(
                'Ver promoções',
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // TEXT BUTTON
            // =========================

            TextButton(
              onPressed: () {
                print('Saiba mais clicado!');
              },
              child: const Text(
                'Saiba mais',
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // BOTÃO COM ÍCONE
            // =========================

            ElevatedButton.icon(
              onPressed: () {
                print('Abrindo jogos gratuitos!');
              },
              icon: const Icon(
                Icons.download,
              ),
              label: const Text(
                'Jogos gratuitos',
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // LINHA DE ICONBUTTONS
            // =========================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    print('Início');
                  },
                  icon: const Icon(
                    Icons.home,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print('Pesquisa');
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
                IconButton(
                  onPressed: favoritos,
                  icon: const Icon(
                    Icons.favorite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // =========================
      // FLOATING ACTION BUTTON
      // =========================

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Novo jogo adicionado!');
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
