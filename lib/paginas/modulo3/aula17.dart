import 'package:flutter/material.dart';

/// Aula 17 - Itens, Missões e HUD
/// 
/// Conteúdo:
/// - Itens coletáveis (`GameDecoration` com sensores de atrito/coleta)
/// - Sistemas de pontuação e inventário de itens (ex: Pendrives 💾)
/// - Gestão de Missões e Objetivos (Quests)
/// - HUD (Heads-Up Display) sobreposto ao canvas do jogo via Flutter Widgets
class Aula17 extends StatefulWidget {
  const Aula17({super.key});

  @override
  State<Aula17> createState() => _Aula17State();
}

class _Aula17State extends State<Aula17> {
  int _pendrivesCollected = 0;
  final int _totalPendrivesNeeded = 2;
  double _hp = 100.0;

  // Lista de Missões (Checklist)
  final List<Map<String, dynamic>> _missions = [
    {"title": "Encontrar os pendrives no laboratório", "completed": false},
    {"title": "Entregar os pendrives ao professor", "completed": false},
    {"title": "Encontrar o código do servidor", "completed": false},
    {"title": "Desbloquear o laboratório principal", "completed": false},
  ];

  void _collectPendrive() {
    if (_pendrivesCollected < _totalPendrivesNeeded) {
      setState(() {
        _pendrivesCollected++;
        if (_pendrivesCollected >= _totalPendrivesNeeded) {
          _missions[0]["completed"] = true; // Completa primeira missão
        }
      });
    }
  }

  void _toggleMission(int index) {
    setState(() {
      _missions[index]["completed"] = !_missions[index]["completed"];
    });
  }

  void _resetGame() {
    setState(() {
      _pendrivesCollected = 0;
      _hp = 100.0;
      for (var m in _missions) {
        m["completed"] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("17 - Itens, Missões e HUD"),
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
                      "Itens Coletáveis, Missões e Camada de HUD",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "O HUD exibe dados vitais (HP, contador de itens coletados, missões ativas) sobrepostos ao mapa do jogo. Os itens usam detecção de toque/sensor (`SensorComponent`) para alterar o estado das missões.",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Visualizador do HUD & Jogo Simulado
            const Text(
              "Demonstração do HUD & Sistema de Missões",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // TELA DO JOGO COM HUD SOBREPOSTO
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
                  // Conteúdo do Cenário no Fundo
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("🧑 PLAYER", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _collectPendrive,
                          icon: const Icon(Icons.save),
                          label: Text(_pendrivesCollected < _totalPendrivesNeeded
                              ? "Coletar Pendrive 💾 ($_pendrivesCollected/$_totalPendrivesNeeded)"
                              : "Pendrives Coletados! 🎉"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pendrivesCollected < _totalPendrivesNeeded ? Colors.blue.shade700 : Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // CAMADA DE HUD (PAINEL SUPERIOR SOBREPOSTO)
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // HP ❤️
                          Row(
                            children: [
                              const Icon(Icons.favorite, color: Colors.red, size: 18),
                              const SizedBox(width: 6),
                              Text("❤️ ${_hp.toInt()}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),

                          // Pendrives 💾
                          Row(
                            children: [
                              const Icon(Icons.save, color: Colors.cyanAccent, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                "💾 ${_pendrivesCollected.toString().padLeft(2, '0')}/$_totalPendrivesNeeded",
                                style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),

                          // Missão Status
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _missions[0]["completed"] ? Colors.green.shade800 : Colors.amber.shade900,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _missions[0]["completed"] ? "Missão 1 OK!" : "Missão Ativa",
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Painel da Lista de Missões (Checklist)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.assignment, color: Colors.purple),
                            SizedBox(width: 8),
                            Text("Exemplo de Checklist de Missão", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        IconButton(
                          onPressed: _resetGame,
                          icon: const Icon(Icons.refresh, size: 20),
                          tooltip: "Reiniciar Teste",
                        ),
                      ],
                    ),
                    const Divider(),
                    ..._missions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final mission = entry.value;
                      final isCompleted = mission["completed"] as bool;

                      return CheckboxListTile(
                        value: isCompleted,
                        title: Text(
                          mission["title"] as String,
                          style: TextStyle(
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                            color: isCompleted ? Colors.grey : Colors.black87,
                            fontWeight: isCompleted ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        activeColor: Colors.purple.shade700,
                        onChanged: (val) => _toggleMission(index),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Código do HUD no Bonfire
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
                        Icon(Icons.dashboard, color: Colors.purpleAccent),
                        SizedBox(width: 8),
                        Text(
                          "Sobrepondo o HUD no BonfireWidget",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '''
BonfireWidget(
  overlayBuilderMap: {
    'PlayerHUD': (context, game) {
      return Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Text('❤️ HP: 100%'),
            Text('💾 Pendrives: 02'),
          ],
        ),
      );
    },
  },
  initialActiveOverlays: const ['PlayerHUD'],
)
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
