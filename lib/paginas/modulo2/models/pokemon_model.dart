/// Modelo de dados (Model) do Pokémon para o Módulo 2
///
/// Encapsula as propriedades recebidas em JSON pela PokéAPI e fornece
/// métodos auxiliares de formatação e parsing desacoplados da View.

class PokemonModel {
  final int id;
  final String name;
  final double heightMeters;
  final double weightKg;
  final String? imageUrl;
  final String? shinyImageUrl;
  final List<String> types;
  final List<PokemonAbilityModel> abilities;
  final List<PokemonStatModel> stats;

  PokemonModel({
    required this.id,
    required this.name,
    required this.heightMeters,
    required this.weightKg,
    this.imageUrl,
    this.shinyImageUrl,
    required this.types,
    required this.abilities,
    required this.stats,
  });

  /// ID formatado com zeros à esquerda (ex: #001, #025, #150)
  String get formattedId => '#${id.toString().padLeft(3, '0')}';

  /// Nome com a primeira letra maiúscula (ex: Pikachu)
  String get displayName =>
      name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : name;

  /// Tipo primário do Pokémon (utilizado para definir temas de cor)
  String get primaryType => types.isNotEmpty ? types.first.toLowerCase() : 'normal';

  /// Factory Constructor para converter o Map vindo do `jsonDecode` da PokéAPI
  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    // 1. Extração de Tipos
    final typesList = (json['types'] as List? ?? [])
        .map((t) => t['type']?['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    // 2. Extração de Habilidades
    final abilitiesList = (json['abilities'] as List? ?? [])
        .map((a) => PokemonAbilityModel.fromJson(a as Map<String, dynamic>))
        .toList();

    // 3. Extração de Estatísticas (Stats)
    final statsList = (json['stats'] as List? ?? [])
        .map((s) => PokemonStatModel.fromJson(s as Map<String, dynamic>))
        .toList();

    // 4. Extração das Imagens (Artwork oficial primeiro, fallback para front_default)
    final sprites = json['sprites'] as Map<String, dynamic>?;
    final officialArtwork = sprites?['other']?['official-artwork'] as Map<String, dynamic>?;

    final String? officialFront = officialArtwork?['front_default'] as String?;
    final String? officialShiny = officialArtwork?['front_shiny'] as String?;
    final String? fallbackFront = sprites?['front_default'] as String?;
    final String? fallbackShiny = sprites?['front_shiny'] as String?;

    // Altura em decímetros -> metros (/ 10)
    final int heightDeci = json['height'] as int? ?? 0;
    // Peso em hectogramas -> kg (/ 10)
    final int weightHecto = json['weight'] as int? ?? 0;

    return PokemonModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      heightMeters: heightDeci / 10.0,
      weightKg: weightHecto / 10.0,
      imageUrl: officialFront ?? fallbackFront,
      shinyImageUrl: officialShiny ?? fallbackShiny,
      types: typesList,
      abilities: abilitiesList,
      stats: statsList,
    );
  }
}

/// Sub-modelo para Habilidades do Pokémon
class PokemonAbilityModel {
  final String name;
  final bool isHidden;

  PokemonAbilityModel({
    required this.name,
    required this.isHidden,
  });

  factory PokemonAbilityModel.fromJson(Map<String, dynamic> json) {
    return PokemonAbilityModel(
      name: json['ability']?['name']?.toString() ?? '',
      isHidden: json['is_hidden'] as bool? ?? false,
    );
  }
}

/// Sub-modelo para Estatísticas de Combate do Pokémon (HP, Ataque, Defesa, etc.)
class PokemonStatModel {
  final String name;
  final int baseStat;

  PokemonStatModel({
    required this.name,
    required this.baseStat,
  });

  /// Nome amigável traduzido para a View
  String get translatedName {
    switch (name.toLowerCase()) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'Ataque';
      case 'defense':
        return 'Defesa';
      case 'special-attack':
        return 'Sp. Ataque';
      case 'special-defense':
        return 'Sp. Defesa';
      case 'speed':
        return 'Velocidade';
      default:
        return name.toUpperCase();
    }
  }

  factory PokemonStatModel.fromJson(Map<String, dynamic> json) {
    return PokemonStatModel(
      name: json['stat']?['name']?.toString() ?? '',
      baseStat: json['base_stat'] as int? ?? 0,
    );
  }
}
