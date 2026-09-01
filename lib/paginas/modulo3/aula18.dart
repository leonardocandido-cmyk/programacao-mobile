import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// ============================================================================
/// AULA 18 - INTEGRACAO DAS MECANICAS 2D, SPRITES PIXEL ART & DS QUEST
/// ============================================================================
/// Conteudo abordado:
/// 1. Renderizacao de Sprites em Estilo Pixel Art (Player, NPCs, Inimigos);
/// 2. Construcao de Mapa Pixel Art com Tilesets (Laboratorio, Salas, Obstaculos);
/// 3. Joystick Virtual de Toque (Controle Analogico 360/8 Direcoes);
/// 4. Mecanica de Batalha (Ataque, Hitbox, Dano, Vida e Derrota de Inimigos);
/// 5. Mecanica de Coleta de Itens (Pendrives, Pocoes e Moedas no Mapa);
/// 6. Fluxo Completo: Menu -> Explora -> Batalha -> Coleta -> Quests -> Vitoria.
/// ============================================================================
class Aula18 extends StatefulWidget {
  const Aula18({super.key});

  @override
  State<Aula18> createState() => _Aula18State();
}

class _Aula18State extends State<Aula18> with SingleTickerProviderStateMixin {
  /// Controlador de Abas para alternar entre o Jogo, o Diagrama e as Equipes
  late TabController _tabController;

  /// Estado de Navegacao do Jogo: 'MENU', 'PLAYING', 'VICTORY', 'GAMEOVER'
  String _gameState = 'MENU';

  /// Loop de Atualizacao (Game Loop em ~60 FPS)
  Timer? _gameLoopTimer;
  DateTime _lastFrameTime = DateTime.now();

  /// --------------------------------------------------------------------------
  /// ATRIBUTOS DO JOGADOR (PLAYER)
  /// --------------------------------------------------------------------------
  double _playerX = 140.0; // Posicao X no mapa
  double _playerY = 160.0; // Posicao Y no mapa
  double _playerSpeed = 2.8; // Velocidade de movimento
  double _playerHp = 100.0; // Vida atual
  final double _playerMaxHp = 100.0; // Vida maxima
  double _playerDirX = 0.0; // Direcao X (-1 a 1)
  double _playerDirY = 1.0; // Direcao Y (-1 a 1)
  bool _isMoving = false; // Indica se esta caminhando
  int _animFrame = 0; // Frame da animacao de caminhada
  int _animCounter = 0;

  /// Sistema de Ataque do Player
  bool _isAttacking = false; // Indica se esta executando o ataque
  int _attackTicks = 0; // Duracao do efeito de ataque
  Rect? _attackHitbox; // Area de colisao do golpe

  /// --------------------------------------------------------------------------
  /// RECURSOS E ESTATISTICAS (HUD & INVENTARIO)
  /// --------------------------------------------------------------------------
  int _pendrivesCollected = 0; // Quantidade de pendrives coletados
  final int _pendrivesRequired = 2; // Quantidade necessaria para a quest
  int _coinsCollected = 0; // Moedas coletadas
  int _score = 0; // Pontuacao total
  bool _talkedToProfessor = false; // Se ja falou com o NPC Professor

  /// --------------------------------------------------------------------------
  /// CONTROLE DO JOYSTICK VIRTUAL DE TOQUE
  /// --------------------------------------------------------------------------
  Offset _joystickBase = Offset.zero; // Posicao central da base do joystick
  Offset _joystickKnob = Offset.zero; // Posicao do botao arrastavel (knob)
  bool _isJoystickActive = false; // Se o usuario esta tocando no joystick

  /// --------------------------------------------------------------------------
  /// ENTIDADES DO JOGO (NPCs, INIMIGOS E ITENS)
  /// --------------------------------------------------------------------------
  // NPC Professor
  final _PixelNpcData _professorNpc = _PixelNpcData(
    name: "Prof. Carvalho",
    x: 210.0,
    y: 65.0,
    dialog: "Encontre os 2 pendrives perdidos e limite os Bugs do laboratorio!",
  );

  // Lista de Inimigos no Mapa (Bugs / Erros de Codigo)
  late List<_PixelEnemyData> _enemies;

  // Lista de Itens Coletaveis no Mapa (Pendrives, Pocoes, Moedas)
  late List<_PixelItemData> _items;

  // Efeitos visuais de dano/particulas temporarias
  final List<_EffectParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _resetWorldEntities();
  }

  @override
  void dispose() {
    _gameLoopTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  /// Reinicia todas as entidades do mundo (Inimigos, Itens e Estado do Player)
  void _resetWorldEntities() {
    _playerX = 140.0;
    _playerY = 160.0;
    _playerHp = 100.0;
    _pendrivesCollected = 0;
    _coinsCollected = 0;
    _score = 0;
    _talkedToProfessor = false;
    _isAttacking = false;
    _particles.clear();

    // Inicializa os Inimigos Pixel Art no mapa
    _enemies = [
      _PixelEnemyData(id: 1, type: 'Bug 👾', x: 60.0, y: 70.0, hp: 40.0, maxHp: 40.0, damage: 12.0),
      _PixelEnemyData(id: 2, type: 'Erro 404 🚫', x: 230.0, y: 150.0, hp: 60.0, maxHp: 60.0, damage: 18.0),
      _PixelEnemyData(id: 3, type: 'Glitch ⚡', x: 70.0, y: 180.0, hp: 35.0, maxHp: 35.0, damage: 15.0),
    ];

    // Inicializa os Itens Coletaveis em Pixel Art
    _items = [
      _PixelItemData(id: 1, type: 'pendrive', x: 45.0, y: 55.0, label: "Pendrive 💾"),
      _PixelItemData(id: 2, type: 'pendrive', x: 245.0, y: 185.0, label: "Pendrive 💾"),
      _PixelItemData(id: 3, type: 'potion', x: 140.0, y: 60.0, label: "Pocao de Vida 🧪"),
      _PixelItemData(id: 4, type: 'coin', x: 110.0, y: 110.0, label: "Moeda DS 🪙"),
      _PixelItemData(id: 5, type: 'coin', x: 180.0, y: 110.0, label: "Moeda DS 🪙"),
    ];
  }

  /// Inicia a partida e liga o Game Loop em 60 FPS
  void _startGame() {
    _resetWorldEntities();
    setState(() {
      _gameState = 'PLAYING';
    });

    _gameLoopTimer?.cancel();
    _lastFrameTime = DateTime.now();
    // Executa a cada ~16ms (60 frames por segundo)
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (_gameState != 'PLAYING') return;

      final now = DateTime.now();
      final dt = now.difference(_lastFrameTime).inMicroseconds / 1000000.0;
      _lastFrameTime = now;

      _updateGameLogic(dt);
    });
  }

  /// ==========================================================================
  /// LÓGICA PRINCIPAL DO GAME LOOP (ATUALIZAÇÃO DE POSIÇÕES, COLISÕES E COMBATE)
  /// ==========================================================================
  void _updateGameLogic(double dt) {
    setState(() {
      // 1. ATUALIZA MOVIMENTO DO PLAYER VIA JOYSTICK
      if (_isJoystickActive && _joystickKnob != Offset.zero) {
        double dx = _joystickKnob.dx;
        double dy = _joystickKnob.dy;
        double dist = sqrt(dx * dx + dy * dy);

        if (dist > 5.0) {
          _playerDirX = dx / dist;
          _playerDirY = dy / dist;
          _isMoving = true;

          // Atualiza posicao garantindo limites do mapa
          double nextX = _playerX + _playerDirX * _playerSpeed;
          double nextY = _playerY + _playerDirY * _playerSpeed;

          // Colisao com bordas do mapa (30px a 270px X, 40px a 220px Y)
          _playerX = nextX.clamp(25.0, 265.0);
          _playerY = nextY.clamp(45.0, 215.0);

          // Anima os passos
          _animCounter++;
          if (_animCounter % 8 == 0) {
            _animFrame = (_animFrame + 1) % 4;
          }
        }
      } else {
        _isMoving = false;
        _animFrame = 0;
      }

      // 2. ATUALIZA TEMPO DE ATAQUE E HITBOX
      if (_isAttacking) {
        _attackTicks--;
        if (_attackTicks <= 0) {
          _isAttacking = false;
          _attackHitbox = null;
        }
      }

      // 3. COLETA DE ITENS AO ENCOSTAR (HITBOX PLAYER vs ITEM)
      final playerRect = Rect.fromLTWH(_playerX - 12, _playerY - 12, 24, 24);
      for (var item in _items) {
        if (!item.isCollected) {
          final itemRect = Rect.fromLTWH(item.x - 10, item.y - 10, 20, 20);
          if (playerRect.overlaps(itemRect)) {
            item.isCollected = true;
            _handleItemCollection(item);
          }
        }
      }

      // 4. ATUALIZA IA DOS INIMIGOS (MOVIMENTO DE PERSEGUIÇÃO & DANO)
      for (var enemy in _enemies) {
        if (enemy.isDead) continue;

        // Distancia ate o player
        double edx = _playerX - enemy.x;
        double edy = _playerY - enemy.y;
        double distToPlayer = sqrt(edx * edx + edy * edy);

        // Perseguicao se o player estiver no raio de visao (< 90px)
        if (distToPlayer < 90.0 && distToPlayer > 16.0) {
          enemy.x += (edx / distToPlayer) * 0.8;
          enemy.y += (edy / distToPlayer) * 0.8;
        }

        // Ataque do inimigo ao encostar no player (< 18px)
        if (distToPlayer <= 18.0 && !enemy.isAttackingCooldown) {
          _playerHp = (_playerHp - enemy.damage).clamp(0.0, _playerMaxHp);
          enemy.isAttackingCooldown = true;

          // Adiciona particula de impacto de dano vermelho
          _particles.add(_EffectParticle(x: _playerX, y: _playerY, text: "-${enemy.damage.toInt()} HP", color: Colors.redAccent));

          // Cooldown de 1 segundo para o inimigo atacar novamente
          Future.delayed(const Duration(milliseconds: 1000), () {
            enemy.isAttackingCooldown = false;
          });

          // Checa se o player morreu
          if (_playerHp <= 0) {
            _gameState = 'GAMEOVER';
          }
        }
      }

      // 5. ATUALIZA PARTICULAS E EFEITOS VISUAIS TEMPORARIOS
      _particles.removeWhere((p) {
        p.life--;
        p.y -= 0.5; // Flutua para cima
        return p.life <= 0;
      });
    });
  }

  /// Processa os efeitos ao coletar um item do mapa
  void _handleItemCollection(_PixelItemData item) {
    if (item.type == 'pendrive') {
      _pendrivesCollected++;
      _score += 100;
      _particles.add(_EffectParticle(x: item.x, y: item.y, text: "+1 Pendrive 💾", color: Colors.cyanAccent));
    } else if (item.type == 'potion') {
      _playerHp = (_playerHp + 30.0).clamp(0.0, _playerMaxHp);
      _score += 50;
      _particles.add(_EffectParticle(x: item.x, y: item.y, text: "+30 HP 🧪", color: Colors.greenAccent));
    } else if (item.type == 'coin') {
      _coinsCollected++;
      _score += 25;
      _particles.add(_EffectParticle(x: item.x, y: item.y, text: "+1 Moeda 🪙", color: Colors.amberAccent));
    }
  }

  /// Executa o Golpe de Ataque do Player em direcao aos inimigos
  void _performPlayerAttack() {
    if (_isAttacking || _gameState != 'PLAYING') return;

    setState(() {
      _isAttacking = true;
      _attackTicks = 12; // Efeito dura ~200ms

      // Calcula a hitbox do golpe na direcao que o jogador esta virado
      double hitX = _playerX + _playerDirX * 24.0 - 16;
      double hitY = _playerY + _playerDirY * 24.0 - 16;
      _attackHitbox = Rect.fromLTWH(hitX, hitY, 32, 32);

      // Checa colisao do ataque com os inimigos
      for (var enemy in _enemies) {
        if (enemy.isDead) continue;

        final enemyRect = Rect.fromLTWH(enemy.x - 12, enemy.y - 12, 24, 24);
        if (_attackHitbox!.overlaps(enemyRect)) {
          enemy.hp -= 25.0; // Aplica 25 de dano
          _particles.add(_EffectParticle(x: enemy.x, y: enemy.y, text: "-25 ⚔️", color: Colors.amber));

          // Empurra o inimigo um pouco para tras (Knockback)
          enemy.x += _playerDirX * 15.0;
          enemy.y += _playerDirY * 15.0;

          // Se a vida do inimigo zerar
          if (enemy.hp <= 0) {
            enemy.isDead = true;
            _score += 150;
            _particles.add(_EffectParticle(x: enemy.x, y: enemy.y, text: "Derrotado! 💀", color: Colors.purpleAccent));
          }
        }
      }
    });
  }

  /// Interacao com o NPC Professor ao se aproximar
  void _interactWithProfessor() {
    final dist = sqrt(pow(_playerX - _professorNpc.x, 2) + pow(_playerY - _professorNpc.y, 2));
    if (dist < 35.0) {
      setState(() {
        _talkedToProfessor = true;
      });

      // Mostra Dialogo
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.purpleAccent, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Text("👨‍🏫 ", style: TextStyle(fontSize: 24)),
              Text(_professorNpc.name, style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(_professorNpc.dialog, style: const TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _checkVictoryCondition();
              },
              child: const Text("Entendido!", style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Aproxime-se do Prof. Carvalho no mapa para conversar!"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  /// Verifica se o jogador cumpriu a missao para vencer o jogo
  void _checkVictoryCondition() {
    if (_pendrivesCollected >= _pendrivesRequired && _talkedToProfessor) {
      setState(() {
        _gameState = 'VICTORY';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("18 - Fluxo Completo & DS Quest"),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.sports_esports), text: "Jogo 2D Pixel Art"),
            Tab(icon: Icon(Icons.alt_route), text: "Fluxo do Jogo"),
            Tab(icon: Icon(Icons.groups), text: "Equipes DS Quest"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ABA 1: PROTOTIPO COMPLETO COM JOYSTICK, PIXEL ART, BATALHA E COLETA
          _buildPixelGameTab(),

          // ABA 2: DIAGRAMA DO FLUXO DO JOGO BONFIRE
          _buildGameFlowTab(),

          // ABA 3: ORGANIZAÇÃO EM EQUIPES PARA O PROJETO FINAL DS QUEST
          _buildTeamsTab(),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// CONSTRUTOR DA ABA PRINCIPAL DO JOGO 2D COM ENGINE SIMULADA EM PIXEL ART
  /// ==========================================================================
  Widget _buildPixelGameTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Explicativo
          Card(
            color: Colors.purple.shade50,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.purple.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.videogame_asset, size: 36, color: Colors.purple),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Protótipo Integrado com Engine Pixel Art 2D",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Use o Joystick Analógico virtual para mover o personagem, colete os pendrives 💾, enfrente os bugs 👾 com o botão de Ataque ⚔️ e fale com o Professor!",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // TELA DO CANVAS DO JOGO 2D
          Container(
            width: double.infinity,
            height: 270,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _gameState == 'VICTORY'
                    ? Colors.greenAccent
                    : (_gameState == 'GAMEOVER' ? Colors.redAccent : Colors.purple.shade400),
                width: 3,
              ),
              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Stack(
                children: [
                  // 1. MENU INICIAL DO JOGO
                  if (_gameState == 'MENU')
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "🎮 DS QUEST: O RETORNO",
                            style: TextStyle(color: Colors.amberAccent, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Módulo 3 - Jogo 2D em Pixel Art",
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _startGame,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text("INICIAR JOGO 2D", style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 2. TELA DO MAPA PIXEL ART EM EXECUÇÃO
                  if (_gameState == 'PLAYING') ...[
                    // RENDERIZADOR DO MAPA, TILES E ENTIDADES (CUSTOM PAINTER PIXEL ART)
                    CustomPaint(
                      size: Size.infinite,
                      painter: _PixelWorldPainter(
                        playerX: _playerX,
                        playerY: _playerY,
                        playerDirX: _playerDirX,
                        playerDirY: _playerDirY,
                        isMoving: _isMoving,
                        animFrame: _animFrame,
                        isAttacking: _isAttacking,
                        attackHitbox: _attackHitbox,
                        professorNpc: _professorNpc,
                        enemies: _enemies,
                        items: _items,
                        particles: _particles,
                      ),
                    ),

                    // CAMADA DE OVERLAY DO HUD (HP, ITENS, PONTUAÇÃO)
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Barra de Vida HP
                            Row(
                              children: [
                                const Icon(Icons.favorite, color: Colors.redAccent, size: 16),
                                const SizedBox(width: 4),
                                SizedBox(
                                  width: 65,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _playerHp / _playerMaxHp,
                                      minHeight: 10,
                                      color: _playerHp > 50 ? Colors.green : Colors.red,
                                      backgroundColor: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text("${_playerHp.toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),

                            // Inventario de Pendrives 💾
                            Row(
                              children: [
                                const Icon(Icons.save, color: Colors.cyanAccent, size: 16),
                                const SizedBox(width: 4),
                                Text("💾 $_pendrivesCollected/$_pendrivesRequired", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 11)),
                              ],
                            ),

                            // Moedas DS 🪙
                            Row(
                              children: [
                                const Icon(Icons.monetization_on, color: Colors.amberAccent, size: 16),
                                const SizedBox(width: 4),
                                Text("🪙 $_coinsCollected", style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 11)),
                              ],
                            ),

                            // Score Total
                            Text("PTS: $_score", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),

                    // JOYSTICK ANALÓGICO VIRTUAL DE TOQUE (CANTO INFERIOR ESQUERDO)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      width: 100,
                      height: 100,
                      child: GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            _isJoystickActive = true;
                            _joystickBase = details.localPosition;
                            _joystickKnob = Offset.zero;
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            Offset delta = details.localPosition - _joystickBase;
                            double distance = delta.distance;
                            double maxRadius = 35.0;

                            if (distance > maxRadius) {
                              _joystickKnob = Offset(
                                (delta.dx / distance) * maxRadius,
                                (delta.dy / distance) * maxRadius,
                              );
                            } else {
                              _joystickKnob = delta;
                            }
                          });
                        },
                        onPanEnd: (_) {
                          setState(() {
                            _isJoystickActive = false;
                            _joystickKnob = Offset.zero;
                          });
                        },
                        child: CustomPaint(
                          size: const Size(100, 100),
                          painter: _PixelJoystickPainter(
                            knobOffset: _joystickKnob,
                            isActive: _isJoystickActive,
                          ),
                        ),
                      ),
                    ),

                    // PAINEL DE AÇÕES DE COMBATE E INTERAÇÃO (CANTO INFERIOR DIREITO)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Row(
                        children: [
                          // Botão de Interação com NPC Professor
                          ElevatedButton(
                            onPressed: _interactWithProfessor,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(14),
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              elevation: 4,
                            ),
                            child: const Text("💬", style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: 8),

                          // Botão de Ataque ⚔️
                          ElevatedButton(
                            onPressed: _performPlayerAttack,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(18),
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              elevation: 6,
                            ),
                            child: const Text("⚔️", style: TextStyle(fontSize: 22)),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // 3. TELA DE VITÓRIA 🎉
                  if (_gameState == 'VICTORY')
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.greenAccent, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("🎉 VITÓRIA COMPLETA!", style: TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text("Você recuperou os $_pendrivesCollected pendrives, derrotou os bugs e completou a quest do Prof. Carvalho!", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12)),
                            const SizedBox(height: 12),
                            Text("Pontuação Final: $_score Pontos", style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _startGame,
                              icon: const Icon(Icons.refresh),
                              label: const Text("Jogar Novamente"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // 4. TELA DE GAME OVER 💀
                  if (_gameState == 'GAMEOVER')
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.redAccent, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("💀 GAME OVER", style: TextStyle(color: Colors.redAccent, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text("Os bugs de codigo derrotaram seu personagem!", style: TextStyle(color: Colors.white, fontSize: 12)),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _startGame,
                              icon: const Icon(Icons.refresh),
                              label: const Text("Tentar Novamente"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Legenda dos Controles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Row(
                children: [
                  Icon(Icons.touch_app, color: Colors.purple, size: 16),
                  SizedBox(width: 4),
                  Text("Arraste o Joystick no canto esquerdo", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.circular(4)),
                    child: const Text("⚔️ Ataque", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.blue.shade700, borderRadius: BorderRadius.circular(4)),
                    child: const Text("💬 Falar NPC", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construtor da Aba 2: Diagrama do Fluxo do Jogo
  Widget _buildGameFlowTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Fluxo Completo da Engine Bonfire 2D", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            color: Colors.grey.shade900,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '''
              MENU INICIAL
                   │
                 JOGAR
                   ↓
              MAPA PIXEL ART
                   │
          ┌────────┴────────┐
          ↓                 ↓
        NPCs            INIMIGOS
     (Professor)      (Bugs 👾)
          │                 │
          └────────┬────────┘
                   ↓
                 ITENS
              (Pendrives 💾)
                   ↓
                MISSÃO
                   ↓
         ┌─────────┴─────────┐
         ↓                   ↓
      VITÓRIA             GAME OVER
         ↓                   ↓
       FINAL              REINICIAR
''',
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construtor da Aba 3: Divisao de Equipes do Projeto Final DS Quest
  Widget _buildTeamsTab() {
    final List<Map<String, String>> teams = [
      {"name": "Equipe 1 - Cenários 🗺️", "desc": "Criação dos mapas no Tiled Editor e tilesets da escola."},
      {"name": "Equipe 2 - Personagens 🧑‍🎓", "desc": "Desenho dos sprites do Player, NPCs e animações Pixel Art."},
      {"name": "Equipe 3 - Mecânicas ⚙️", "desc": "Programação dos inimigos (Bugs), ataques, inventário e Quests."},
      {"name": "Equipe 4 - Interface (HUD) 📊", "desc": "Desenvolvimento do Menu Inicial, barras de HP e Joysticks."},
      {"name": "Equipe 5 - Áudio e Polimento 🎵", "desc": "Trilha sonora 8-bits, efeitos sonoros e testes de colisão."},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("🎮 Projeto Final - DS Quest (Trabalho em Grupo)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text(
            "Após as 6 aulas do Módulo 3, a turma se divide em 5 equipes especializadas para construir o jogo final!",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ...teams.map((t) => Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.group, color: Colors.white)),
                  title: Text(t["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(t["desc"]!),
                ),
              )),
        ],
      ),
    );
  }
}

/// ============================================================================
/// CLASSES DE DADOS PARA ENTIDADES DO JOGO (NPCs, INIMIGOS, ITENS E EFEITOS)
/// ============================================================================
class _PixelNpcData {
  final String name;
  final double x;
  final double y;
  final String dialog;

  _PixelNpcData({required this.name, required this.x, required this.y, required this.dialog});
}

class _PixelEnemyData {
  final int id;
  final String type;
  double x;
  double y;
  double hp;
  double maxHp;
  double damage;
  bool isDead = false;
  bool isAttackingCooldown = false;

  _PixelEnemyData({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.hp,
    required this.maxHp,
    required this.damage,
  });
}

class _PixelItemData {
  final int id;
  final String type; // 'pendrive', 'potion', 'coin'
  final double x;
  final double y;
  final String label;
  bool isCollected = false;

  _PixelItemData({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.label,
  });
}

class _EffectParticle {
  double x;
  double y;
  final String text;
  final Color color;
  int life = 30; // 30 frames de vida

  _EffectParticle({required this.x, required this.y, required this.text, required this.color});
}

/// ============================================================================
/// CUSTOM PAINTER: RENDERIZADOR DO MAPA PIXEL ART, TILES E SPRITES
/// ============================================================================
class _PixelWorldPainter extends CustomPainter {
  final double playerX;
  final double playerY;
  final double playerDirX;
  final double playerDirY;
  final bool isMoving;
  final int animFrame;
  final bool isAttacking;
  final Rect? attackHitbox;

  final _PixelNpcData professorNpc;
  final List<_PixelEnemyData> enemies;
  final List<_PixelItemData> items;
  final List<_EffectParticle> particles;

  _PixelWorldPainter({
    required this.playerX,
    required this.playerY,
    required this.playerDirX,
    required this.playerDirY,
    required this.isMoving,
    required this.animFrame,
    required this.isAttacking,
    required this.attackHitbox,
    required this.professorNpc,
    required this.enemies,
    required this.items,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. DESENHA O CHÃO QUADRICULADO PIXEL ART (LABORATÓRIO & SALAS)
    final gridPaint = Paint()
      ..color = const Color(0xFF1E1E2C)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), gridPaint);

    final tileBorderPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    // Linhas dos Tiles 16x16
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), tileBorderPaint);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), tileBorderPaint);
    }

    // 2. DESENHA AS PAREDES E ESTRUTURAS DO LABORATÓRIO E SALA DE AULA
    final wallPaint = Paint()..color = const Color(0xFF3F3D56);
    // Parede Superior
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 35), wallPaint);
    // Divisoria das salas
    canvas.drawRect(Rect.fromLTWH(135, 35, 12, 100), wallPaint);

    // Texto dos Ambientes no Chao
    final textStyle = TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 10, fontWeight: FontWeight.bold);
    final textPainter1 = TextPainter(text: TextSpan(text: "LABORATÓRIO 💻", style: textStyle), textDirection: TextDirection.ltr);
    textPainter1.layout();
    textPainter1.paint(canvas, const Offset(30, 45));

    final textPainter2 = TextPainter(text: TextSpan(text: "SALA DE AULA 🏫", style: textStyle), textDirection: TextDirection.ltr);
    textPainter2.layout();
    textPainter2.paint(canvas, const Offset(160, 45));

    // 3. DESENHA OS ITENS COLETÁVEIS EM PIXEL ART
    for (var item in items) {
      if (item.isCollected) continue;

      if (item.type == 'pendrive') {
        // Sprite de Pendrive Pixel Art (Retangulo com Conector Prata e LED Azul)
        final bodyPaint = Paint()..color = Colors.black;
        final tipPaint = Paint()..color = Colors.grey.shade300;
        final ledPaint = Paint()..color = Colors.cyanAccent;

        canvas.drawRect(Rect.fromLTWH(item.x - 6, item.y - 4, 12, 8), bodyPaint);
        canvas.drawRect(Rect.fromLTWH(item.x + 6, item.y - 2, 4, 4), tipPaint);
        canvas.drawCircle(Offset(item.x - 2, item.y), 1.5, ledPaint);
      } else if (item.type == 'potion') {
        // Sprite de Pocao de Vida (Frasco Vermelho Pixel Art)
        final potionPaint = Paint()..color = Colors.redAccent;
        final glassPaint = Paint()..color = Colors.white70;

        canvas.drawCircle(Offset(item.x, item.y + 2), 5, potionPaint);
        canvas.drawRect(Rect.fromLTWH(item.x - 2, item.y - 5, 4, 4), glassPaint);
      } else if (item.type == 'coin') {
        // Sprite de Moeda DS (Circulo Dourado)
        final coinPaint = Paint()..color = Colors.amberAccent;
        final coinBorder = Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        canvas.drawCircle(Offset(item.x, item.y), 5, coinPaint);
        canvas.drawCircle(Offset(item.x, item.y), 5, coinBorder);
      }
    }

    // 4. DESENHA O NPC PROFESSOR 👨‍🏫 (SPRITE PIXEL ART COM BALÃO DE SPEECH)
    final npcBodyPaint = Paint()..color = Colors.blue.shade800;
    final npcHeadPaint = Paint()..color = const Color(0xFFFFD1B3);
    final npcGlassesPaint = Paint()..color = Colors.black;

    // Corpo e Cabeça
    canvas.drawRect(Rect.fromLTWH(professorNpc.x - 8, professorNpc.y - 2, 16, 16), npcBodyPaint);
    canvas.drawCircle(Offset(professorNpc.x, professorNpc.y - 8), 7, npcHeadPaint);
    // Óculos de Pixel
    canvas.drawRect(Rect.fromLTWH(professorNpc.x - 5, professorNpc.y - 10, 4, 3), npcGlassesPaint);
    canvas.drawRect(Rect.fromLTWH(professorNpc.x + 1, professorNpc.y - 10, 4, 3), npcGlassesPaint);

    // Balão de Fala do NPC [Falar E]
    final speechBg = Paint()..color = Colors.amber;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(professorNpc.x - 20, professorNpc.y - 30, 40, 14), const Radius.circular(6)), speechBg);

    final npcText = TextPainter(
      text: const TextSpan(text: "💬 Prof.", style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    );
    npcText.layout();
    npcText.paint(canvas, Offset(professorNpc.x - 16, professorNpc.y - 28));

    // 5. DESENHA OS INIMIGOS (BUGS 👾 PIXEL ART)
    for (var enemy in enemies) {
      if (enemy.isDead) continue;

      final bugPaint = Paint()..color = (enemy.type.contains('404') ? Colors.orangeAccent : Colors.redAccent);
      final eyePaint = Paint()..color = Colors.white;

      // Corpo de Bug Pixelado
      canvas.drawCircle(Offset(enemy.x, enemy.y), 8, bugPaint);
      // Olhos
      canvas.drawCircle(Offset(enemy.x - 3, enemy.y - 2), 2, eyePaint);
      canvas.drawCircle(Offset(enemy.x + 3, enemy.y - 2), 2, eyePaint);

      // Barra de HP do Inimigo
      final hpBg = Paint()..color = Colors.black;
      final hpFg = Paint()..color = Colors.greenAccent;
      canvas.drawRect(Rect.fromLTWH(enemy.x - 10, enemy.y - 14, 20, 3), hpBg);
      canvas.drawRect(Rect.fromLTWH(enemy.x - 10, enemy.y - 14, (enemy.hp / enemy.maxHp) * 20, 3), hpFg);
    }

    // 6. DESENHA O JOGADOR (PLAYER PIXEL ART COM ANIMAÇÃO DE CAMINHADA)
    final shadowPaint = Paint()..color = Colors.black38;
    canvas.drawOval(Rect.fromLTWH(playerX - 8, playerY + 8, 16, 6), shadowPaint);

    final playerHeadPaint = Paint()..color = const Color(0xFFFFC107);
    final playerShirtPaint = Paint()..color = Colors.purpleAccent;
    final playerPantsPaint = Paint()..color = Colors.deepPurple;

    // Deslocamento de pernas ao andar
    double legOffset = isMoving ? (animFrame % 2 == 0 ? 3.0 : -3.0) : 0.0;

    // Pernas
    canvas.drawRect(Rect.fromLTWH(playerX - 6 + legOffset, playerY + 6, 4, 6), playerPantsPaint);
    canvas.drawRect(Rect.fromLTWH(playerX + 2 - legOffset, playerY + 6, 4, 6), playerPantsPaint);
    // Tronco
    canvas.drawRect(Rect.fromLTWH(playerX - 7, playerY - 4, 14, 10), playerShirtPaint);
    // Cabeça
    canvas.drawCircle(Offset(playerX, playerY - 10), 7, playerHeadPaint);

    // 7. DESENHA EFEITO VISUAL DE ATAQUE ⚔️ (HITBOX & CORTE PIXEL)
    if (isAttacking && attackHitbox != null) {
      final attackPaint = Paint()
        ..color = Colors.amberAccent.withOpacity(0.6)
        ..style = PaintingStyle.fill;
      canvas.drawRect(attackHitbox!, attackPaint);

      final attackBorder = Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(attackHitbox!, attackBorder);
    }

    // 8. DESENHA PARTICULAS DE DANO E MENSAGENS FLUTUANTES
    for (var particle in particles) {
      final pPainter = TextPainter(
        text: TextSpan(text: particle.text, style: TextStyle(color: particle.color, fontSize: 11, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      );
      pPainter.layout();
      pPainter.paint(canvas, Offset(particle.x - 10, particle.y - 20));
    }
  }

  @override
  bool shouldRepaint(covariant _PixelWorldPainter oldDelegate) => true;
}

/// ============================================================================
/// CUSTOM PAINTER: RENDERIZADOR DO JOYSTICK ANALÓGICO VIRTUAL DE TOQUE
/// ============================================================================
class _PixelJoystickPainter extends CustomPainter {
  final Offset knobOffset;
  final bool isActive;

  _PixelJoystickPainter({required this.knobOffset, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Base Circular Translucida
    final basePaint = Paint()
      ..color = isActive ? Colors.purple.withOpacity(0.35) : Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 40, basePaint);

    final baseBorder = Paint()
      ..color = isActive ? Colors.purpleAccent : Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, 40, baseBorder);

    // Botao Arrastavel (Knob)
    final knobCenter = center + knobOffset;
    final knobPaint = Paint()
      ..color = isActive ? Colors.amberAccent : Colors.purpleAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(knobCenter, 16, knobPaint);
  }

  @override
  bool shouldRepaint(covariant _PixelJoystickPainter oldDelegate) => true;
}
