import 'dart:convert';
import 'package:flutter_app/paginas/modulo2/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

/// Controller/Service da Aula 11 (FutureBuilder com Pokédex em Grid)
///
/// Encapsula a lógica assíncrona para buscar múltiplos Pokémons da PokéAPI
/// e retornar objetos `PokemonModel` fortemente tipados para a View.
class Aula11Controller {
  /// Busca a lista inicial de Pokémons da PokéAPI e converte em List<PokemonModel>
  Future<List<PokemonModel>> fetchPokemons({int limit = 20, int offset = 0}) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Falha ao conectar com a PokéAPI (HTTP ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List results = data['results'] ?? [];

    final List<PokemonModel> pokemonList = [];

    for (var item in results) {
      final detailUrl = Uri.parse(item['url']);
      final detailResponse = await http.get(detailUrl);
      if (detailResponse.statusCode == 200) {
        final detailData = jsonDecode(detailResponse.body) as Map<String, dynamic>;
        pokemonList.add(PokemonModel.fromJson(detailData));
      }
    }

    return pokemonList;
  }
}
