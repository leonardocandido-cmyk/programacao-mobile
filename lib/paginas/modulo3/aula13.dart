import 'package:flutter/material.dart';

/// Aula 13 - Bonfire e Personagem
/// 
/// Conteúdo Teórico e Prático:
/// - Configuração do Bonfire / Flame Engine
/// - Estrutura do jogo (Game Widget, Game Loop)
/// - Mundo e Câmera inicial
/// - Player (Criando o personagem principal)
/// - Sprite e Spritesheet de animação
/// - Controles (Joystick virtual e Teclado)
/// - Movimentação do personagem no espaço 2D
class Aula13 extends StatefulWidget {
  const Aula13({super.key});

  @override
  State<Aula13> createState() => _Aula13State();
}

class _Aula13State extends State<Aula13> {
  // Posição do Player no Canvas simulado
  double _playerX = 130.0;
  double _playerY = 70.0;
  double _speed = 4.0;
  String _facingDirection = 'down'; // down, up, left, right
  bool _isMoving = false;

  // Joystick virtual state
  void _move(double dx, double dy, String direction) {
    setState(() {
      _playerX = (_playerX + dx * _speed).clamp(10.0, 250.0);
      _playerY = (_playerY + dy * _speed).clamp(10.0, 130.0);
      _facingDirection = direction;
      _isMoving = true;
    });
  }

  void _stopMove() {
    setState(() {
      _isMoving = false;
    });
  }

  IconData _getPlayerIcon() {
    switch (_facingDirection) {
      case 'up':
        return Icons.arrow_upward;
      case 'down':
        return Icons.arrow_downward;
      case 'left':
        return Icons.arrow_back;
      case 'right':
        return Icons.arrow_forward;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("13 - Bonfire e Personagem"),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner do Bonfire
            Card(
              color: Colors.purple.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.purple.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department, size: 40, color: Colors.deepOrange),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "O que é a Bonfire Engine?",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Bonfire é um RPG Engine 2D construído em cima do Flame. Ele facilita a criação de personagens (Player/NPC), mapas Tile, movimentação com Joystick, animações Sprite e colisão.",
                            style: TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Resultado Prático
            const Text(
              "Resultado Prático: Personagem Controlável",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Use os botões de controle abaixo para mover o personagem pelo cenário simples:",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Canvas de Jogo Simulado
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.shade400, width: 2),
              ),
              child: Stack(
                children: [
                  // Grade de fundo (Grid)
                  CustomPaint(
                    size: Size.infinite,
                    painter: _GridPainter(),
                  ),

                  // Player no Canvas
                  Positioned(
                    left: _playerX,
                    top: _playerY,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Player (${_playerX.toInt()}, ${_playerY.toInt()})",
                            style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 2),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _isMoving ? Colors.amber : Colors.blueAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: _isMoving ? 8 : 4,
                                spreadRadius: _isMoving ? 2 : 0,
                              ),
                            ],
                          ),
                          child: Icon(_getPlayerIcon(), color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),

                  // Status de Animação
                  Positioned(
                    bottom: 8,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Animação: ${_isMoving ? 'WALK_${_facingDirection.toUpperCase()}' : 'IDLE_${_facingDirection.toUpperCase()}'}",
                        style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontFamily: 'monospace'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // D-Pad / Controles do Player
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _move(0, -1, 'up'),
                      icon: const Icon(Icons.keyboard_arrow_up),
                      style: IconButton.styleFrom(backgroundColor: Colors.purple.shade700, foregroundColor: Colors.white),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _move(-1, 0, 'left'),
                          icon: const Icon(Icons.keyboard_arrow_left),
                          style: IconButton.styleFrom(backgroundColor: Colors.purple.shade700, foregroundColor: Colors.white),
                        ),
                        const SizedBox(width: 32),
                        IconButton(
                          onPressed: () => _move(1, 0, 'right'),
                          icon: const Icon(Icons.keyboard_arrow_right),
                          style: IconButton.styleFrom(backgroundColor: Colors.purple.shade700, foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _move(0, 1, 'down'),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: IconButton.styleFrom(backgroundColor: Colors.purple.shade700, foregroundColor: Colors.white),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Velocidade: ${_speed.toStringAsFixed(1)}x", style: const TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 140,
                      child: Slider(
                        value: _speed,
                        min: 1.0,
                        max: 10.0,
                        activeColor: Colors.purple,
                        onChanged: (val) => setState(() => _speed = val),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _stopMove,
                      icon: const Icon(Icons.stop),
                      label: const Text("Parar Player"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade800, foregroundColor: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Card de Exemplo de Código Bonfire
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
                        Icon(Icons.code, color: Colors.deepOrangeAccent),
                        SizedBox(width: 8),
                        Text(
                          "Como declarar o BonfireWidget & SimplePlayer",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '''
BonfireWidget(
  joystick: Joystick(
    directional: JoystickDirectional(),
  ),
  player: SimplePlayer(
    position: Vector2(100, 100),
    size: Vector2(32, 32),
    animation: SimpleDirectionAnimation(
      idleRight: SpriteAnimation.load('player_idle.png', ...),
      runRight: SpriteAnimation.load('player_run.png', ...),
    ),
    speed: 150,
  ),
  map: WorldMapByTiled(
    WorldMapReader.asset('mapa_escola.json'),
  ),
)
''',
                      style: TextStyle(
                        color: Colors.greenAccent,
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

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
