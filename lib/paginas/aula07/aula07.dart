import 'package:flutter/material.dart';

/// Aula 07 - StatefulWidget
///
/// Conteúdo:
/// - Conceito de estado e reconstrução reativa da UI
/// - Uso do método [setState]
/// - Atributos mutáveis e interação do usuário (cliques, contadores, alternadores)
///
/// Projeto: Interface Interativa (Contador de Pontos & Sistema de Favoritos)
class Aula07 extends StatefulWidget {
  const Aula07({super.key});

  @override
  State<Aula07> createState() => _Aula07State();
}

class _Aula07State extends State<Aula07> {
  // Variáveis de estado mutáveis
  int _contador = 0;
  bool _eFavorito = false;
  int _totalCurtidas = 10;

  // Métodos manipuladores de estado
  void _incrementar() {
    setState(() {
      _contador++;
    });
  }

  void _decrementar() {
    if (_contador > 0) {
      setState(() {
        _contador--;
      });
    }
  }

  void _zerar() {
    setState(() {
      _contador = 0;
    });
  }

  void _alternarFavorito() {
    setState(() {
      _eFavorito = !_eFavorito;
      if (_eFavorito) {
        _totalCurtidas++;
      } else {
        _totalCurtidas--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aula 07 - StatefulWidget'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Explicação inicial
            const Text(
              'O que é um StatefulWidget?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Diferente do StatelessWidget, o StatefulWidget pode alterar seu conteúdo '
              'na tela em resposta a ações do usuário chamando o método setState().',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // =========================================================
            // CARD 1: CONTADOR INTERATIVO
            // =========================================================
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Contador de Pontos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$_contador',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _decrementar,
                          icon: const Icon(Icons.remove),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _zerar,
                          icon: const Icon(Icons.refresh),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _incrementar,
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================================================
            // CARD 2: BOTÃO DE FAVORITO (ALTERNADOR DE ESTADO)
            // =========================================================
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Interação de Favorito',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 40,
                          icon: Icon(
                            _eFavorito ? Icons.favorite : Icons.favorite_border,
                            color: _eFavorito ? Colors.red : Colors.grey,
                          ),
                          onPressed: _alternarFavorito,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$_totalCurtidas curtidas',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _eFavorito ? 'Você marcou como favorito!' : 'Clique no coração para favoritar.',
                      style: TextStyle(
                        fontSize: 12,
                        color: _eFavorito ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
