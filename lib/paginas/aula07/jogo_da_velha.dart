import 'dart:math';
import 'package:flutter/material.dart';

/// Atividade Prática - Jogo da Velha (com IA / Computador)
///
/// Conceitos praticados:
/// - StatefulWidget e setState para gerenciamento de estado
/// - Lógica de jogo contra o computador (IA básica de ataque/defesa)
/// - GridView.builder para renderização em grade 3x3
/// - Renderização dinâmica de ícones (Vazio, Xis e Quadrado)
class JogoDaVelhaPage extends StatefulWidget {
  const JogoDaVelhaPage({super.key});

  @override
  State<JogoDaVelhaPage> createState() => _JogoDaVelhaPageState();
}

class _JogoDaVelhaPageState extends State<JogoDaVelhaPage> {
  // Estado do tabuleiro 3x3 (9 células)
  List<String> _tabuleiro = List.filled(9, '');

  // Modo de jogo: true = Contra o Computador, false = 2 Jogadores
  bool _contraComputador = true;

  // Controle de turno: true = Xis (X), false = Quadrado (Q)
  bool _turnoDoX = true;
  String _mensagemStatus = 'Sua vez (Xis - X)';
  bool _jogoFinalizado = false;

  // Realiza a jogada do jogador humano
  void _jogar(int index) {
    if (_tabuleiro[index] != '' || _jogoFinalizado) return;

    // Se estiver no modo contra computador e for a vez da IA, ignora o toque
    if (_contraComputador && !_turnoDoX) return;

    setState(() {
      _tabuleiro[index] = _turnoDoX ? 'X' : 'Q';
      _verificarVencedor();

      if (!_jogoFinalizado) {
        _turnoDoX = !_turnoDoX;
        _mensagemStatus = _contraComputador
            ? 'Pensando...'
            : (_turnoDoX ? 'Vez do Xis (X)' : 'Vez do Quadrado (Q)');
      }
    });

    // Se for modo contra computador e for o turno da IA, executa a jogada da CPU
    if (_contraComputador && !_turnoDoX && !_jogoFinalizado) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        _jogadaComputador();
      });
    }
  }

  // Lógica da jogada do Computador (IA)
  void _jogadaComputador() {
    if (_jogoFinalizado) return;

    int melhorJogada = _encontrarMelhorJogada();
    if (melhorJogada != -1) {
      setState(() {
        _tabuleiro[melhorJogada] = 'Q';
        _verificarVencedor();

        if (!_jogoFinalizado) {
          _turnoDoX = true;
          _mensagemStatus = 'Sua vez (Xis - X)';
        }
      });
    }
  }

  // IA: Tenta ganhar -> Tenta bloquear o jogador -> Ocupa o centro -> Pega posição aleatória
  int _encontrarMelhorJogada() {
    const combinacoesVitoria = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Linhas
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Colunas
      [0, 4, 8], [2, 4, 6],           // Diagonais
    ];

    // 1. Tenta ganhar no próximo movimento
    for (var pos in combinacoesVitoria) {
      int contQ = 0;
      int vazioIndex = -1;
      for (int i in pos) {
        if (_tabuleiro[i] == 'Q') contQ++;
        if (_tabuleiro[i] == '') vazioIndex = i;
      }
      if (contQ == 2 && vazioIndex != -1) return vazioIndex;
    }

    // 2. Tenta bloquear a vitória do jogador (X)
    for (var pos in combinacoesVitoria) {
      int contX = 0;
      int vazioIndex = -1;
      for (int i in pos) {
        if (_tabuleiro[i] == 'X') contX++;
        if (_tabuleiro[i] == '') vazioIndex = i;
      }
      if (contX == 2 && vazioIndex != -1) return vazioIndex;
    }

    // 3. Prefere a posição central se estiver livre
    if (_tabuleiro[4] == '') return 4;

    // 4. Seleciona uma posição livre aleatória
    List<int> posicoesVazias = [];
    for (int i = 0; i < 9; i++) {
      if (_tabuleiro[i] == '') posicoesVazias.add(i);
    }

    if (posicoesVazias.isNotEmpty) {
      final random = Random();
      return posicoesVazias[random.nextInt(posicoesVazias.length)];
    }

    return -1;
  }

  // Verifica as combinações de vitória (linhas, colunas e diagonais)
  void _verificarVencedor() {
    const combinacoesVitoria = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var pos in combinacoesVitoria) {
      if (_tabuleiro[pos[0]] != '' &&
          _tabuleiro[pos[0]] == _tabuleiro[pos[1]] &&
          _tabuleiro[pos[0]] == _tabuleiro[pos[2]]) {
        String vencedor;
        if (_tabuleiro[pos[0]] == 'X') {
          vencedor = 'Você Venceu! 🎉';
        } else {
          vencedor = _contraComputador ? 'Computador Venceu! 🤖' : 'Jogador Quadrado Venceu! 🎉';
        }
        _mensagemStatus = vencedor;
        _jogoFinalizado = true;
        return;
      }
    }

    // Verifica empate caso todas as posições estejam preenchidas
    if (!_tabuleiro.contains('')) {
      _mensagemStatus = '🤝 Empate! Deu Velha!';
      _jogoFinalizado = true;
    }
  }

  // Reinicia a partida
  void _reiniciarJogo() {
    setState(() {
      _tabuleiro = List.filled(9, '');
      _turnoDoX = true;
      _mensagemStatus = _contraComputador ? 'Sua vez (Xis - X)' : 'Vez do Xis (X)';
      _jogoFinalizado = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atividade - Jogo da Velha'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner e Seletor de Modo de Jogo
            Card(
              elevation: 2,
              color: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _contraComputador ? Icons.smart_toy : Icons.people,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _contraComputador ? 'vs Computador' : '2 Jogadores',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Modo CPU', style: TextStyle(fontSize: 12)),
                        Switch(
                          value: _contraComputador,
                          activeColor: Colors.deepPurple,
                          onChanged: (val) {
                            setState(() {
                              _contraComputador = val;
                              _reiniciarJogo();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Card principal do jogo
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Status do Jogo
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: _jogoFinalizado ? Colors.amber.shade100 : Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _mensagemStatus,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _jogoFinalizado ? Colors.amber.shade900 : Colors.deepPurple,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tabuleiro 3x3 utilizando GridView.builder
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        String valor = _tabuleiro[index];

                        // Ícones dos estados: Vazio, Xis ou Quadrado
                        Widget icone;
                        if (valor == 'X') {
                          icone = const Icon(
                            Icons.close,
                            size: 52,
                            color: Colors.blueAccent,
                          );
                        } else if (valor == 'Q') {
                          icone = const Icon(
                            Icons.crop_square,
                            size: 52,
                            color: Colors.deepOrange,
                          );
                        } else {
                          icone = Icon(
                            Icons.check_box_outline_blank,
                            size: 48,
                            color: Colors.grey.shade300,
                          );
                        }

                        return InkWell(
                          onTap: () => _jogar(index),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: valor.isEmpty
                                    ? Colors.grey.shade300
                                    : (valor == 'X' ? Colors.blueAccent : Colors.deepOrange),
                                width: 2,
                              ),
                            ),
                            child: Center(child: icone),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Botão para reiniciar a partida
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _reiniciarJogo,
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'Reiniciar Jogo',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
