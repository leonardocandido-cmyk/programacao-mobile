import 'package:flutter/material.dart';
import 'package:flutter_app/paginas/modulo2/controllers/aula09_controller.dart';
import 'package:flutter_app/paginas/modulo2/models/pokemon_model.dart';

/// Aula 09 - View (Interface de Usuário)
///
/// Focada puramente em apresentação. Toda a regra de simulação
/// e manipulação de estado resida no `Aula09Controller`.
class Aula09 extends StatefulWidget {
  const Aula09({super.key});

  @override
  State<Aula09> createState() => _Aula09State();
}

class _Aula09State extends State<Aula09> {
  late final Aula09Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = Aula09Controller();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("09 - Introdução às APIs REST (MVC)"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final pokemonModel = _controller.currentPokemonModel;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner de Cabeçalho
                Card(
                  color: Colors.red.shade50,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.api, size: 40, color: Colors.redAccent),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "O que é uma API REST?",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "API é uma ponte de comunicação entre nosso aplicativo e um servidor remoto. O servidor responde no formato JSON que o Model desacopla e parseia.",
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

                // Conceitos Chave (Cards Informativos)
                const Text(
                  "Conceitos Fundamentais (MVC)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildConceptCard(
                        icon: Icons.http,
                        title: "HTTP GET",
                        description: "Solicita dados sem alterá-los.",
                        color: Colors.blue.shade100,
                        iconColor: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildConceptCard(
                        icon: Icons.data_object,
                        title: "Model & JSON",
                        description: "Converte mapas de JSON em objetos tipados.",
                        color: Colors.amber.shade100,
                        iconColor: Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Seletor de Pokémon
                const Text(
                  "Simulador de Requisição & Model",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Selecione um Pokémon no Controller para ver a URL do Endpoint e o Model instanciado:",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // Chips do Controller
                Wrap(
                  spacing: 8,
                  children: _controller.availablePokemons.map((name) {
                    final isSelected = _controller.selectedPokemonName == name;
                    return ChoiceChip(
                      label: Text(
                        name.toUpperCase(),
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.redAccent,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (selected) {
                        if (selected) {
                          _controller.selecionarPokemon(name);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Display do Model e Endpoint
                _buildEndpointAndModelDisplay(pokemonModel),

                const SizedBox(height: 20),

                // Bloco Dica do Professor
                const Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb, color: Colors.amber),
                            SizedBox(width: 8),
                            Text(
                              "Dica de Arquitetura (MVC)",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Com a separação em MVC, a View não precisa saber como o JSON é estruturado. Ela interage apenas com as propriedades limpas e fortemente tipadas do `PokemonModel`!",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEndpointAndModelDisplay(PokemonModel pokemon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "GET",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _controller.currentEndpointUrl,
                  style: const TextStyle(color: Colors.lightGreenAccent, fontFamily: 'monospace', fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),

          // Renderização via Model
          Row(
            children: [
              if (pokemon.imageUrl != null)
                Image.network(pokemon.imageUrl!, width: 60, height: 60),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${pokemon.displayName} (${pokemon.formattedId})",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tipo: ${pokemon.primaryType.toUpperCase()} | Altura: ${pokemon.heightMeters}m | Peso: ${pokemon.weightKg}kg",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Text(
            "Payload JSON Bruto (Controller):",
            style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _controller.formattedJsonString,
              style: const TextStyle(color: Colors.amberAccent, fontFamily: 'monospace', fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConceptCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: iconColor),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
