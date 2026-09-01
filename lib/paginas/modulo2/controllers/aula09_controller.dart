import 'package:flutter/material.dart';
import 'package:flutter_app/paginas/modulo2/models/pokemon_model.dart';

/// Controller da Aula 09 (Introdução a APIs REST e JSON)
///
/// Separa os dados de exemplo, simulação de requisição e formatação
/// da interface de usuário (View).
class Aula09Controller extends ChangeNotifier {
  String _selectedPokemonName = 'pikachu';

  // Base de dados simulada para os exemplos teóricos da Aula 09
  final Map<String, Map<String, dynamic>> _mockPayloads = {
    'pikachu': {
      'id': 25,
      'name': 'pikachu',
      'height': 4,
      'weight': 60,
      'types': [
        {'type': {'name': 'electric'}}
      ],
      'sprites': {
        'front_default': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
        'other': {
          'official-artwork': {
            'front_default': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png'
          }
        }
      }
    },
    'charmander': {
      'id': 4,
      'name': 'charmander',
      'height': 6,
      'weight': 85,
      'types': [
        {'type': {'name': 'fire'}}
      ],
      'sprites': {
        'front_default': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',
        'other': {
          'official-artwork': {
            'front_default': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png'
          }
        }
      }
    },
    'bulbasaur': {
      'id': 1,
      'name': 'bulbasaur',
      'height': 7,
      'weight': 69,
      'types': [
        {'type': {'name': 'grass'}},
        {'type': {'name': 'poison'}}
      ],
      'sprites': {
        'front_default': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
        'other': {
          'official-artwork': {
            'front_default': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png'
          }
        }
      }
    },
    'squirtle': {
      'id': 7,
      'name': 'squirtle',
      'height': 5,
      'weight': 90,
      'types': [
        {'type': {'name': 'water'}}
      ],
      'sprites': {
        'front_default': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png',
        'other': {
          'official-artwork': {
            'front_default': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png'
          }
        }
      }
    },
  };

  String get selectedPokemonName => _selectedPokemonName;
  List<String> get availablePokemons => _mockPayloads.keys.toList();

  /// URL simulada do endpoint
  String get currentEndpointUrl => 'https://pokeapi.co/api/v2/pokemon/$_selectedPokemonName';

  /// Retorna o modelo fortemente tipado do Pokémon selecionado
  PokemonModel get currentPokemonModel =>
      PokemonModel.fromJson(_mockPayloads[_selectedPokemonName]!);

  /// Retorna a string do JSON formatada para exibição no código
  String get formattedJsonString {
    final map = _mockPayloads[_selectedPokemonName]!;
    final buffer = StringBuffer();
    buffer.writeln('{');
    map.forEach((key, value) {
      if (value is String) {
        buffer.writeln('  "$key": "$value",');
      } else {
        buffer.writeln('  "$key": $value,');
      }
    });
    buffer.write('}');
    return buffer.toString();
  }

  /// Altera o Pokémon selecionado e notifica a View
  void selecionarPokemon(String name) {
    if (_mockPayloads.containsKey(name) && _selectedPokemonName != name) {
      _selectedPokemonName = name;
      notifyListeners();
    }
  }
}
