import 'package:flutter/material.dart';

/// Aula 14 - Mapas, Câmera e Colisões
/// 
/// Conteúdo:
/// - Mapas 2D (Tiled Maps, Matrix Maps)
/// - Tiles e Tilesets (grade de blocos 16x16 / 32x32)
/// - Câmera (Seguindo o jogador e definindo zoom)
/// - Limites de mapa (Boundaries)
/// - Colisões de cenário (Caixas de colisão / Impenetrabilidade)
/// - Objetos do cenário (Computadores, mesas, paredes)
class Aula14 extends StatefulWidget {
  const Aula14({super.key});

  @override
  State<Aula14> createState() => _Aula14State();
}

class _Aula14State extends State<Aula14> {
  // Posição do Player no mapa da escola
  double _playerX = 140.0;
  double _playerY = 120.0;
  String _currentRoom = 'Corredor';
  bool _collisionAlert = false;

  // Paredes/Obstáculos simulados (Rects)
  final List<Rect> _obstacles = [
    const Rect.fromLTWH(20, 20, 240, 15),   // Parede Superior
    const Rect.fromLTWH(20, 175, 240, 15),  // Parede Inferior
    const Rect.fromLTWH(15, 20, 15, 170),   // Parede Esquerda
    const Rect.fromLTWH(250, 20, 15, 170),  // Parede Direita
    const Rect.fromLTWH(20, 95, 240, 10),   // Divisória do Laboratório
  ];

  void _tryMove(double dx, double dy) {
    final nextX = _playerX + dx;
    final nextY = _playerY + dy;
    final playerRect = Rect.fromLTWH(nextX, nextY, 20, 20);

    bool collides = false;
    for (final obs in _obstacles) {
      if (playerRect.overlaps(obs)) {
        collides = true;
        break;
      }
    }

    setState(() {
      if (collides) {
        _collisionAlert = true;
      } else {
        _playerX = nextX;
        _playerY = nextY;
        _collisionAlert = false;

        // Atualizar Sala Atual
        if (_playerY < 95) {
          _currentRoom = 'Laboratório 💻';
        } else if (_playerX < 130) {
          _currentRoom = 'Sala de Aula 🏫';
        } else {
          _currentRoom = 'Corredor 🏃';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("14 - Mapas, Câmera e Colisões"),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teoria
            Card(
              color: Colors.purple.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.purple.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Construindo o Cenário da Escola em 2D",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "No Bonfire, os mapas são criados com o editor Tiled (.tmx/.json) divididos em Tileset (quadros de imagem) e camadas de colisão. A câmera segue o jogador automaticamente e impede que ele atravesse paredes.",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Visualizador do Mapa Escolar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mapa Escolar Explorável",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Local: $_currentRoom",
                    style: TextStyle(color: Colors.purple.shade900, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Canvas de Mapa Simulado
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _collisionAlert ? Colors.redAccent : Colors.purple.shade400,
                  width: _collisionAlert ? 3 : 2,
                ),
              ),
              child: Stack(
                children: [
                  // Estrutura Visual dos Ambientes
                  // Laboratório (Parte Superior)
                  Positioned(
                    top: 25,
                    left: 30,
                    right: 30,
                    height: 65,
                    child: Container(
                      color: Colors.blue.withOpacity(0.15),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("LABORATÓRIO", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 11)),
                          SizedBox(height: 4),
                          Text("💻  💻  💻  💻", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),

                  // Sala de Aula (Parte Inferior Esquerda)
                  Positioned(
                    top: 110,
                    left: 30,
                    width: 95,
                    height: 60,
                    child: Container(
                      color: Colors.green.withOpacity(0.15),
                      child: const Center(
                        child: Text("SALA DE AULA\n🏫  📚", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightGreenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),

                  // Corredor (Parte Inferior Direita)
                  Positioned(
                    top: 110,
                    left: 130,
                    right: 30,
                    height: 60,
                    child: Container(
                      color: Colors.orange.withOpacity(0.15),
                      child: const Center(
                        child: Text("CORREDOR\n🚶  🚪", textAlign: TextAlign.center, style: TextStyle(color: Colors.amberAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),

                  // Desenho das Paredes (Paredes de Colisão)
                  ..._obstacles.map((obs) => Positioned(
                    left: obs.left,
                    top: obs.top,
                    width: obs.width,
                    height: obs.height,
                    child: Container(
                      color: Colors.red.withOpacity(0.4),
                    ),
                  )),

                  // Player 🧑
                  Positioned(
                    left: _playerX,
                    top: _playerY,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black45, blurRadius: 4),
                        ],
                      ),
                      child: const Center(
                        child: Text("🧑", style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ),

                  // Alerta de Colisão
                  if (_collisionAlert)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text("Colisão com Parede!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Controles de Movimentação do Aluno no Mapa
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _tryMove(0, -10),
                      icon: const Icon(Icons.arrow_upward),
                      style: IconButton.styleFrom(backgroundColor: Colors.purple.shade700, foregroundColor: Colors.white),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _tryMove(-10, 0),
                          icon: const Icon(Icons.arrow_back),
                          style: IconButton.styleFrom(backgroundColor: Colors.purple.shade700, foregroundColor: Colors.white),
                        ),
                        const SizedBox(width: 40),
                        IconButton(
                          onPressed: () => _tryMove(10, 0),
                          icon: const Icon(Icons.arrow_forward),
                          style: IconButton.styleFrom(backgroundColor: Colors.purple.shade700, foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _tryMove(0, 10),
                      icon: const Icon(Icons.arrow_downward),
                      style: IconButton.styleFrom(backgroundColor: Colors.purple.shade700, foregroundColor: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Código de Colisão no Bonfire
            Card(
              color: Colors.grey.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security, color: Colors.purpleAccent),
                        SizedBox(width: 8),
                        Text(
                          "Adicionando Colisão aos Objetos (Bonfire)",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '''
class MesaEscolar extends GameDecoration with ObjectCollision {
  MesaEscolar(Vector2 position)
      : super.withSprite(
          sprite: Sprite.load('mesa.png'),
          position: position,
          size: Vector2(32, 32),
        ) {
    // Configura a caixa de colisão impenetrable
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(size: Vector2(32, 32)),
        ],
      ),
    );
  }
}
''',
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
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
