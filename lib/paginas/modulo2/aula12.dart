import 'package:flutter/material.dart';
import 'package:flutter_app/paginas/modulo2/controllers/aula12_controller.dart';
import 'package:flutter_app/paginas/modulo2/models/pokemon_model.dart';

/// Aula 12 - View (Pokédex Completa com Arquitetura MVC)
///
/// Interface de usuário desacoplada que consome o `Aula12Controller`
/// e renderiza os dados através do `PokemonModel`.
class Aula12 extends StatefulWidget {
  const Aula12({super.key});

  @override
  State<Aula12> createState() => _Aula12State();
}

class _Aula12State extends State<Aula12> {
  late final Aula12Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = Aula12Controller();
    _controller.carregarPagina();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.catching_pokemon, color: Colors.white),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                "12 - Pokédex Completa (MVC)",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Column(
            children: [
              // Barra de Pesquisa acoplada ao Controller
              Container(
                padding: const EdgeInsets.all(12.0),
                color: Colors.red.shade700,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller.searchController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: "Buscar por Nome ou Número...",
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(Icons.search, color: Colors.red),
                          suffixIcon: _controller.searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.grey),
                                  onPressed: _controller.limparBusca,
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _controller.buscarPokemon(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _controller.buscarPokemon,
                      tooltip: "Buscar",
                    ),
                  ],
                ),
              ),

              // Área Principal (Loading, Erro ou Grid de PokemonModel)
              Expanded(
                child: _controller.isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.red),
                            SizedBox(height: 16),
                            Text("Acessando Pokédex via Controller...", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : _controller.errorMessage != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.warning_amber_rounded, size: 60, color: Colors.orange),
                                  const SizedBox(height: 12),
                                  Text(
                                    _controller.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16, color: Colors.redAccent),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _controller.limparBusca,
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                                    child: const Text("Voltar à Lista"),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(10),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: _controller.pokemonList.length,
                            itemBuilder: (context, index) {
                              final pokemon = _controller.pokemonList[index];
                              return _buildPokemonCard(pokemon);
                            },
                          ),
              ),

              // Controles de Paginação
              if (!_controller.isSearching && !_controller.isLoading && _controller.errorMessage == null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _controller.canGoBack ? _controller.paginaAnterior : null,
                        icon: const Icon(Icons.arrow_back_ios, size: 14),
                        label: const Text("Anterior"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      Text(
                        "Página ${_controller.currentPage}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      ElevatedButton.icon(
                        onPressed: _controller.proximaPagina,
                        icon: const Icon(Icons.arrow_forward_ios, size: 14),
                        label: const Text("Próximo"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPokemonCard(PokemonModel pokemon) {
    final Color cardColor = _getTypeColor(pokemon.primaryType);

    return GestureDetector(
      onTap: () => _abrirDetalhesPokemon(pokemon),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [cardColor.withOpacity(0.85), cardColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Número ID do Model
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    pokemon.formattedId,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ),

              // Nome do Model
              Text(
                pokemon.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Badges dos Tipos
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: pokemon.types.map<Widget>((typeName) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      typeName.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),

              // Sprite Imagem
              Expanded(
                child: Center(
                  child: pokemon.imageUrl != null
                      ? Image.network(
                          pokemon.imageUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.catching_pokemon, size: 50, color: Colors.white),
                        )
                      : const Icon(Icons.catching_pokemon, size: 50, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Abre Modal/BottomSheet com detalhes completos a partir do PokemonModel
  void _abrirDetalhesPokemon(PokemonModel pokemon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PokemonDetailsModal(pokemon: pokemon),
    );
  }

  /// Helper de Cores por Tipo de Pokémon
  static Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.orange.shade700;
      case 'water':
        return Colors.blue.shade600;
      case 'grass':
        return Colors.green.shade600;
      case 'electric':
        return Colors.amber.shade700;
      case 'psychic':
        return Colors.purple.shade500;
      case 'ice':
        return Colors.cyan.shade400;
      case 'dragon':
        return Colors.indigo.shade700;
      case 'dark':
        return Colors.grey.shade800;
      case 'fairy':
        return Colors.pink.shade300;
      case 'fighting':
        return Colors.deepOrange.shade800;
      case 'poison':
        return Colors.purple.shade700;
      case 'ground':
        return Colors.brown.shade600;
      case 'flying':
        return Colors.indigo.shade300;
      case 'bug':
        return Colors.lightGreen.shade700;
      case 'rock':
        return Colors.brown.shade400;
      case 'ghost':
        return Colors.deepPurple.shade600;
      case 'steel':
        return Colors.blueGrey.shade500;
      default:
        return Colors.grey.shade600;
    }
  }
}

/// Modal com visualização detalhada do PokemonModel
class _PokemonDetailsModal extends StatefulWidget {
  final PokemonModel pokemon;
  const _PokemonDetailsModal({required this.pokemon});

  @override
  State<_PokemonDetailsModal> createState() => _PokemonDetailsModalState();
}

class _PokemonDetailsModalState extends State<_PokemonDetailsModal> {
  bool _showShiny = false;

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;
    final Color mainColor = _Aula12State._getTypeColor(pokemon.primaryType);

    final String? activeImageUrl = _showShiny
        ? (pokemon.shinyImageUrl ?? pokemon.imageUrl)
        : pokemon.imageUrl;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              // Cabeçalho da Modal com cor temática
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            pokemon.displayName.toUpperCase(),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          pokemon.formattedId,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            children: pokemon.types.map<Widget>((t) {
                              return Chip(
                                backgroundColor: Colors.white24,
                                label: Text(
                                  t.toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Alternador de Sprite (Shiny ✨)
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showShiny = !_showShiny;
                            });
                          },
                          icon: Icon(_showShiny ? Icons.star : Icons.star_border, color: Colors.amber),
                          label: Text(_showShiny ? "Shiny ✨" : "Normal"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black26,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Imagem vinda do Model
                    SizedBox(
                      height: 160,
                      child: activeImageUrl != null
                          ? Image.network(
                              activeImageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(Icons.catching_pokemon, size: 80, color: Colors.white),
                            )
                          : const Icon(Icons.catching_pokemon, size: 80, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Informações detalhadas do Model
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetric("ALTURA", "${pokemon.heightMeters} m"),
                        _buildMetric("PESO", "${pokemon.weightKg} kg"),
                      ],
                    ),
                    const Divider(height: 30),

                    // Habilidades (PokemonAbilityModel)
                    const Text("HABILIDADES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: pokemon.abilities.map<Widget>((ability) {
                        return Chip(
                          avatar: Icon(ability.isHidden ? Icons.visibility_off : Icons.bolt, size: 16),
                          label: Text(ability.name + (ability.isHidden ? " (Oculta)" : "")),
                          backgroundColor: Colors.grey.shade200,
                        );
                      }).toList(),
                    ),
                    const Divider(height: 30),

                    // Stats (PokemonStatModel)
                    const Text("ESTATÍSTICAS BASE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 12),
                    ...pokemon.stats.map((stat) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                stat.translatedName,
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              width: 35,
                              child: Text(
                                stat.baseStat.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: (stat.baseStat / 150).clamp(0.0, 1.0),
                                  minHeight: 8,
                                  color: mainColor,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
