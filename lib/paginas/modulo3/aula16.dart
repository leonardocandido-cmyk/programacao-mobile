import 'package:flutter/material.dart';

/// Aula 16 - Inimigos, Vida e Dano
/// 
/// Conteúdo:
/// - Inimigos no Bonfire (`SimpleEnemy`)
/// - Detecção do jogador (`seePlayer` / `seeAndMoveToPlayer`)
/// - Inteligência Artificial de perseguição e patrulha
/// - Sistemas de Dano (`receiveDamage`) e Vida (`LifeComponent`)
/// - Tela e fluxo de Game Over básico
/// - Inimigos Temáticos: Bug 🐛, Glitch ⚡, Erro 404 🚫, Vírus 🦠
class Aula16 extends StatefulWidget {
  const Aula16({super.key});

  @override
  State<Aula16> createState() => _Aula16State();
}

class _Aula16State extends State<Aula16> {
  double _playerHp = 80.0;
  final double _maxHp = 100.0;
  bool _isGameOver = false;

  // Inimigo selecionado para teste
  String _selectedEnemy = 'Bug 🐛';

  // Informações dos Inimigos Temáticos
  final Map<String, Map<String, dynamic>> _enemyTypes = {
    'Bug 🐛': {
      'icon': Icons.bug_report,
      'color': Colors.lightGreenAccent,
      'dano': 15.0,
      'desc': 'Bug simples de código. Ataca em linha reta.',
    },
    'Glitch ⚡': {
      'icon': Icons.flash_on,
      'color': Colors.cyanAccent,
      'dano': 25.0,
      'desc': 'Erro visual instável. Movimenta-se rápido e imprevisível.',
    },
    'Erro 404 🚫': {
      'icon': Icons.block,
      'color': Colors.orangeAccent,
      'dano': 35.0,
      'desc': 'Recurso não encontrado! Bloqueia passagem e causa grande dano.',
    },
    'Vírus 🦠': {
      'icon': Icons.coronavirus,
      'color': Colors.redAccent,
      'dano': 50.0,
      'desc': 'Ameaça crítica! Persegue o jogador constantemente.',
    },
  };

  void _takeDamage(double damage) {
    if (_isGameOver) return;
    setState(() {
      _playerHp = (_playerHp - damage).clamp(0.0, _maxHp);
      if (_playerHp <= 0) {
        _isGameOver = true;
      }
    });
  }

  void _healPlayer() {
    setState(() {
      _playerHp = 100.0;
      _isGameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentEnemyData = _enemyTypes[_selectedEnemy]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("16 - Inimigos, Vida e Dano"),
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
                      "Inimigos e Sistema de Combate no Bonfire",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Com `SimpleEnemy`, o Bonfire gerencia a visão do inimigo (seeAndMoveToPlayer) e colisão de ataque. Quando a vida do jogador zera, dispara-se a função de Game Over.",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Canvas de Teste de Dano e Inimigos
            const Text(
              "Simulador de Combate & Barra de Vida",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isGameOver ? Colors.red : Colors.purple.shade400,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  // BARRA DE VIDA (❤️ HP 80%)
                  Row(
                    children: [
                      const Text("❤️ VIDA:", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _playerHp / _maxHp,
                            minHeight: 16,
                            color: _playerHp > 50 ? Colors.green : (_playerHp > 20 ? Colors.orange : Colors.red),
                            backgroundColor: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${_playerHp.toInt()}%",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Área de Simulação Visual do Inimigo Atacando o Player
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: _isGameOver
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("💀 GAME OVER", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: _healPlayer,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text("Tentar Novamente"),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                ),
                              ],
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Player 🧑
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircleAvatar(radius: 22, backgroundColor: Colors.amber, child: Text("🧑", style: TextStyle(fontSize: 22))),
                                  const SizedBox(height: 4),
                                  Text("Player HP: ${_playerHp.toInt()}", style: const TextStyle(color: Colors.white, fontSize: 11)),
                                ],
                              ),

                              const Icon(Icons.arrow_back, color: Colors.redAccent, size: 30),

                              // Inimigo Atacante
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.red.shade900,
                                    child: Icon(currentEnemyData['icon'] as IconData, color: currentEnemyData['color'] as Color, size: 24),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(_selectedEnemy, style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Seleção de Inimigos Temáticos
            const Text("Escolha um Inimigo Temático para testar o Ataque:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _enemyTypes.keys.map((enemyName) {
                final isSelected = enemyName == _selectedEnemy;
                return ChoiceChip(
                  label: Text(enemyName),
                  selected: isSelected,
                  selectedColor: Colors.purple.shade700,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedEnemy = enemyName);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Botão de Receber Dano do Inimigo Selecionado
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isGameOver ? null : () => _takeDamage(currentEnemyData['dano'] as double),
                    icon: const Icon(Icons.flash_on),
                    label: Text("Receber Dano de $_selectedEnemy (-${(currentEnemyData['dano'] as double).toInt()} HP)"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _healPlayer,
                  icon: const Icon(Icons.healing),
                  tooltip: "Restaurar Vida",
                  style: IconButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Exemplo de Código SimpleEnemy
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
                        Icon(Icons.bug_report, color: Colors.redAccent),
                        SizedBox(width: 8),
                        Text(
                          "Criando Inimigo com Visão & Dano (Bonfire)",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '''
class BugEnemy extends SimpleEnemy with ObjectCollision {
  BugEnemy(Vector2 position)
      : super(
          position: position,
          size: Vector2(32, 32),
          speed: 80,
        );

  @override
  void update(double dt) {
    super.update(dt);
    // Persegue o jogador se estiver próximo e ataca ao tocar
    seeAndMoveToPlayer(
      closePlayer: (player) {
        simpleAttackMelee(
          damage: 15,
          size: Vector2(32, 32),
        );
      },
      radiusVision: 120,
    );
  }
}
''',
                      style: TextStyle(
                        color: Colors.redAccent,
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
