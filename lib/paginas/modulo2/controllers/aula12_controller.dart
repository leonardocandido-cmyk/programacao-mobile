import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/paginas/modulo2/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

/// Controller da Aula 12 (Pokédex Completa)
///
/// Responsável pelo gerenciamento de estado da Pokédex (paginação, busca por filtro,
/// requisições HTTP à PokéAPI e controle da lista de `PokemonModel`).
class Aula12Controller extends ChangeNotifier {
  static const int _limit = 12;
  int _offset = 0;
  int _currentPage = 1;

  final TextEditingController searchController = TextEditingController();

  bool _isSearching = false;
  bool _isLoading = false;
  String? _errorMessage;

  List<PokemonModel> _pokemonList = [];

  int get currentPage => _currentPage;
  int get offset => _offset;
  bool get canGoBack => _offset >= _limit;
  bool get isSearching => _isSearching;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PokemonModel> get pokemonList => List.unmodifiable(_pokemonList);

  /// Carrega a página atual de Pokémons
  Future<void> carregarPagina() async {
    _isLoading = true;
    _errorMessage = null;
    _isSearching = false;
    notifyListeners();

    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$_limit&offset=$_offset');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];

        final List<PokemonModel> detalhados = [];
        for (var item in results) {
          final res = await http.get(Uri.parse(item['url']));
          if (res.statusCode == 200) {
            detalhados.add(PokemonModel.fromJson(jsonDecode(res.body)));
          }
        }

        _pokemonList = detalhados;
        _isLoading = false;
      } else {
        _errorMessage = "Erro ao carregar dados da PokéAPI (HTTP ${response.statusCode})";
        _isLoading = false;
      }
    } catch (e) {
      _errorMessage = "Falha de rede. Verifique sua conexão com a internet.";
      _isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  /// Busca um Pokémon específico pelo nome ou ID
  Future<void> buscarPokemon() async {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      carregarPagina();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _isSearching = true;
    notifyListeners();

    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _pokemonList = [PokemonModel.fromJson(data)];
        _isLoading = false;
      } else {
        _errorMessage = 'Nenhum Pokémon encontrado com o termo "$query".';
        _pokemonList = [];
        _isLoading = false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao realizar a busca. Tente novamente.';
      _pokemonList = [];
      _isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  void limparBusca() {
    searchController.clear();
    carregarPagina();
  }

  void paginaAnterior() {
    if (_offset >= _limit) {
      _offset -= _limit;
      _currentPage--;
      carregarPagina();
    }
  }

  void proximaPagina() {
    _offset += _limit;
    _currentPage++;
    carregarPagina();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
