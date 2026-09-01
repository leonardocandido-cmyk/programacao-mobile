import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/paginas/modulo2/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

/// Controller da Aula 10 (Primeira Requisição HTTP)
///
/// Encapsula a lógica de negócio, requisição HTTP via `http.get`
/// e conversão de JSON para o modelo `PokemonModel`.
class Aula10Controller extends ChangeNotifier {
  final TextEditingController textController = TextEditingController(text: 'pikachu');

  bool _isLoading = false;
  String? _errorMessage;
  PokemonModel? _pokemon;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PokemonModel? get pokemon => _pokemon;

  /// Método principal de busca de Pokémon via HTTP
  Future<void> buscarPokemon() async {
    final query = textController.text.trim().toLowerCase();

    if (query.isEmpty) {
      _errorMessage = 'Por favor, digite o nome ou ID de um Pokémon.';
      _pokemon = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _pokemon = PokemonModel.fromJson(data);
        _errorMessage = null;
      } else if (response.statusCode == 404) {
        _errorMessage = 'Pokémon "$query" não encontrado (Status 404).';
        _pokemon = null;
      } else {
        _errorMessage = 'Erro na requisição. Código HTTP: ${response.statusCode}';
        _pokemon = null;
      }
    } catch (e) {
      _errorMessage = 'Falha na conexão com a PokéAPI. Verifique sua internet.';
      _pokemon = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
