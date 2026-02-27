import 'package:pokemon_api_v1/domain/entities/pokemon.dart';

class PokemonModel extends Pokemon {
  PokemonModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.types,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'], 
      name: json['name'], 
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ?? '', 
      types: (json['types'] as List).map((t) => t['type']['name'].toString()).toList(),
    );
  }
}
