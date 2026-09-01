import 'package:flutter/material.dart';
import 'package:flutter_app/paginas/modulo2/controllers/aula11_controller.dart';
import 'package:flutter_app/paginas/modulo2/models/pokemon_model.dart';

/// Aula 11 - View (FutureBuilder com MVC & PokemonModel)
///
/// Apresenta o `FutureBuilder` consumindo a lista de `PokemonModel`
/// retornada pelo `Aula11Controller`.
class Aula11 extends StatefulWidget {
  const Aula11({super.key});

  @override
  State<Aula11> createState() => _Aula11State();
}

class _Aula11State extends State<Aula11> {
  final Aula11Controller _controller = Aula11Controller();
  late Future<List<PokemonModel>> _pokemonsFuture;

  @override
  void initState() {
    super.initState();
    _pokemonsFuture = _controller.fetchPokemons();
  }

  void _recarregar() {
    setState(() {
      _pokemonsFuture = _controller.fetchPokemons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("11 - FutureBuilder (MVC)"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Recarregar Lista",
            onPressed: _recarregar,
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Explicativo
          Container(
            width: double.infinity,
            color: Colors.red.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Row(
              children: [
                Icon(Icons.architecture, color: Colors.redAccent),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "O FutureBuilder consome Future<List<PokemonModel>> do Controller e constrói a interface conforme o estado da conexão.",
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          // FutureBuilder fortemente tipado
          Expanded(
            child: FutureBuilder<List<PokemonModel>>(
              future: _pokemonsFuture,
              builder: (context, snapshot) {
                // Estado 1: Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.redAccent),
                        SizedBox(height: 16),
                        Text(
                          "Controller buscando List<PokemonModel>...",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // Estado 2: Erro
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            "Erro: ${snapshot.error}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _recarregar,
                            icon: const Icon(Icons.refresh),
                            label: const Text("Tentar Novamente"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Estado 3: Sucesso
                if (snapshot.hasData) {
                  final pokemons = snapshot.data!;

                  if (pokemons.isEmpty) {
                    return const Center(child: Text("Nenhum Pokémon encontrado."));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: pokemons.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokemons[index];
                      return _buildPokemonGridCard(pokemon);
                    },
                  );
                }

                return const Center(child: Text("Sem dados."));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonGridCard(PokemonModel pokemon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.red.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ID formatado vindo do Model
            Align(
              alignment: Alignment.topRight,
              child: Text(
                pokemon.formattedId,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),

            // Sprite imagem
            Expanded(
              child: pokemon.imageUrl != null
                  ? Image.network(
                      pokemon.imageUrl!,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.redAccent),
                        );
                      },
                    )
                  : const Icon(Icons.catching_pokemon, size: 40),
            ),
            const SizedBox(height: 6),

            // Nome vindo do Model
            Text(
              pokemon.displayName.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Badges dos Tipos
            Wrap(
              spacing: 4,
              children: pokemon.types.map<Widget>((typeName) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    typeName,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
