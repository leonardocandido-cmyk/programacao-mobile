import 'package:flutter/material.dart';
import 'package:flutter_app/paginas/modulo2/controllers/aula10_controller.dart';
import 'package:flutter_app/paginas/modulo2/models/pokemon_model.dart';

/// Aula 10 - View (Primeira Requisição HTTP com MVC)
///
/// Interface de usuário reativa que escuta o `Aula10Controller` e renderiza
/// os dados fortemente tipados do `PokemonModel`.
class Aula10 extends StatefulWidget {
  const Aula10({super.key});

  @override
  State<Aula10> createState() => _Aula10State();
}

class _Aula10State extends State<Aula10> {
  late final Aula10Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = Aula10Controller();
    _controller.buscarPokemon();
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
        title: const Text("10 - Primeira Requisição HTTP (MVC)"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Consumindo a PokéAPI com Controller & Model",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Digite o nome ou ID de um Pokémon para que o Controller realize a requisição:",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Form de Busca acoplado ao Controller
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller.textController,
                        decoration: InputDecoration(
                          labelText: "Nome ou Número (ex: charizard, 25)",
                          hintText: "pikachu",
                          prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        onSubmitted: (_) => _controller.buscarPokemon(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _controller.isLoading ? null : _controller.buscarPokemon,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Buscar"),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Estado 1: Loading
                if (_controller.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: Colors.redAccent),
                          SizedBox(height: 16),
                          Text("Controller requisitando PokéAPI (http.get)...", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                // Estado 2: Erro
                else if (_controller.errorMessage != null)
                  Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _controller.errorMessage!,
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                // Estado 3: Sucesso com Model
                else if (_controller.pokemon != null)
                  _buildPokemonCard(_controller.pokemon!),

                const SizedBox(height: 24),

                // Bloco Explicativo do Código
                _buildCodeExplanation(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPokemonCard(PokemonModel pokemon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Nome e ID formatado vindo do Model
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pokemon.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pokemon.formattedId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Imagem do Pokémon vinda do Model
            Container(
              height: 180,
              width: 180,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: pokemon.imageUrl != null
                  ? Image.network(
                      pokemon.imageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.catching_pokemon, size: 80, color: Colors.white),
                    )
                  : const Icon(Icons.catching_pokemon, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Badges dos Tipos
            Wrap(
              spacing: 8,
              children: pokemon.types.map<Widget>((type) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white54),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Métricas (Altura em metros e Peso em kg vindos do Model)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text("ALTURA", style: TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(
                        "${pokemon.heightMeters} m",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  Container(height: 30, width: 1, color: Colors.white30),
                  Column(
                    children: [
                      const Text("PESO", style: TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(
                        "${pokemon.weightKg} kg",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeExplanation() {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code, color: Colors.lightGreenAccent),
                SizedBox(width: 8),
                Text(
                  "Fluxo MVC na Requisição",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '''
// 1. Controller faz a requisição:
final response = await http.get(url);

// 2. Model parseia o JSON:
final pokemon = PokemonModel.fromJson(jsonDecode(response.body));

// 3. View consome o Model:
Text(pokemon.displayName);
''',
              style: TextStyle(
                color: Colors.lightGreenAccent,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
