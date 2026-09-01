import 'package:flutter/material.dart';

/// Aula 15 - NPCs e Interação
/// 
/// Conteúdo:
/// - O que são NPCs (Non-Player Characters / SimpleNpc no Bonfire)
/// - Detecção de proximidade com o jogador (seePlayer)
/// - Sistemas de Diálogo (TalkDialog e caixas de fala estilizadas)
/// - Eventos desencadeados pelas conversas com NPCs
class Aula15 extends StatefulWidget {
  const Aula15({super.key});

  @override
  State<Aula15> createState() => _Aula15State();
}

class _Aula15State extends State<Aula15> {
  // Posição do Player e do Professor NPC
  double _playerX = 50.0;
  final double _playerY = 70.0;

  final double _npcX = 190.0;
  final double _npcY = 70.0;

  bool _isNearNpc = false;
  bool _dialogOpen = false;
  int _dialogStep = 0;

  final List<Map<String, String>> _dialogues = [
    {
      "speaker": "👨‍🏫 Professor",
      "text": "Olá, aluno! Preciso da sua ajuda urgente!",
    },
    {
      "speaker": "👨‍🏫 Professor",
      "text": "Encontre o pendrive perdido no laboratório!",
    },
    {
      "speaker": "🧑 Aluno",
      "text": "Pode deixar, professor! Vou procurar agora mesmo no laboratório.",
    },
  ];

  void _movePlayer(double dx) {
    setState(() {
      _playerX = (_playerX + dx).clamp(20.0, 220.0);
      _checkProximity();
    });
  }

  void _checkProximity() {
    final distance = (_playerX - _npcX).abs();
    _isNearNpc = distance < 45;
    if (!_isNearNpc) {
      _dialogOpen = false;
      _dialogStep = 0;
    }
  }

  void _startDialog() {
    setState(() {
      _dialogOpen = true;
      _dialogStep = 0;
    });
  }

  void _nextDialog() {
    setState(() {
      if (_dialogStep < _dialogues.length - 1) {
        _dialogStep++;
      } else {
        _dialogOpen = false;
        _dialogStep = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("15 - NPCs e Interação"),
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
                      "Interação com NPCs e Caixas de Diálogo",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Os NPCs dão vida ao jogo e iniciam missões. No Bonfire, usamos o componente `SimpleNpc` junto com o utilitário `TalkDialog.show()` para exibir balões de conversa animados quando o jogador se aproxima.",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Visualizador da Interação Player -> Professor NPC
            const Text(
              "Demonstração de Interação com NPC",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Aproxime o Aluno 🧑 do Professor 👨‍🏫 para liberar o botão de diálogo:",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Canvas de Jogo Simulado
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.shade400, width: 2),
              ),
              child: Stack(
                children: [
                  // Professor NPC 👨‍🏫
                  Positioned(
                    left: _npcX,
                    top: _npcY,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "👨‍🏫 PROFESSOR",
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blueAccent,
                          child: Text("👨‍🏫", style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),

                  // Player Aluno 🧑
                  Positioned(
                    left: _playerX,
                    top: _playerY,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade900,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "🧑 PLAYER",
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.amber,
                          child: Text("🧑", style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),

                  // Balão de Indicação "Pressione Falar" em cima do NPC
                  if (_isNearNpc && !_dialogOpen)
                    Positioned(
                      left: _npcX - 15,
                      top: _npcY - 35,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.chat_bubble, size: 12, color: Colors.black),
                            SizedBox(width: 4),
                            Text("Falar [E]", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),

                  // CAIXA DE DIÁLOGO FLAME / BONFIRE (SOBREPOSIÇÃO)
                  if (_dialogOpen)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Card(
                        color: Colors.black.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.purpleAccent, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _dialogues[_dialogStep]["speaker"]!,
                                style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\"${_dialogues[_dialogStep]["text"]!}\"",
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton.icon(
                                  onPressed: _nextDialog,
                                  icon: const Icon(Icons.arrow_forward, size: 16),
                                  label: Text(_dialogStep < _dialogues.length - 1 ? "Próximo ▸" : "Fechar ✖"),
                                  style: TextButton.styleFrom(foregroundColor: Colors.purpleAccent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Botões de Movimentação e Ação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _movePlayer(-20),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Aproximar (Esq)"),
                ),
                ElevatedButton.icon(
                  onPressed: _isNearNpc ? _startDialog : null,
                  icon: const Icon(Icons.forum),
                  label: const Text("Iniciar Diálogo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _movePlayer(20),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Aproximar (Dir)"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Código de Exemplo TalkDialog
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
                        Icon(Icons.chat, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          "Exemplo do TalkDialog no Bonfire",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '''
TalkDialog.show(
  context,
  [
    Say(
      text: [TextSpan(text: "Encontre o pendrive perdido no laboratório!")],
      person: Sprite.load('professor_face.png').asWidget(),
      personSayDirection: PersonSayDirection.LEFT,
    ),
  ],
);
''',
                      style: TextStyle(
                        color: Colors.amberAccent,
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
