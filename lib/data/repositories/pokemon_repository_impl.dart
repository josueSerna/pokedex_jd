import 'package:pokemon_api_v1/core/error/failure.dart';
import 'package:pokemon_api_v1/core/network/api_client.dart';
import 'package:pokemon_api_v1/core/network/either.dart';
import 'package:pokemon_api_v1/data/models/pokemon_model.dart';
import 'package:pokemon_api_v1/domain/enums/pokemon_form.dart';
import 'package:pokemon_api_v1/domain/repositories/pokemon_respository.dart';

class PokemonRepositoryImpl implements PokemonRespository {
  final ApiClient apiClient;

  List<String>? _allPokemonNames;
  PokemonRepositoryImpl(this.apiClient);

  @override
  Future<Either<Failure, List<PokemonModel>>> getPokemons({
    int limit = 20,
    int offset = 0,
  }) async {
    // final url = 'https://pokeapi.co/api/v2/';
    final pokemonResult = await apiClient.request(
      '/pokemon-species',
      queryParameters: {'limit': '$limit', 'offset': '$offset'},
      onSuccess: (body) {
        final results = body['results'] as List<dynamic>;
        return results.map((e) => e['name'] as String).toList();
      },
    );
    if (pokemonResult.isLeft) {
      return Left(pokemonResult.left!);
    }
    final names = pokemonResult.rigth!;

    final futures = names
        .map(
          (name) => apiClient.request(
            '/pokemon/$name',
            onSuccess: (body) =>
                PokemonModel.fromJson(body as Map<String, dynamic>),
          ),
        )
        .toList();

    final pokemonList = await Future.wait(futures);
    final pokemons = <PokemonModel>[];
    for (final pokemon in pokemonList) {
      pokemon.fold((_) {}, pokemons.add);
    }

    if (pokemons.isEmpty) {
      return Left(ServerFailure('No se cargaron'));
    }
    return Rigth(pokemons);
  }

  @override
  Future<Either<Failure, List<PokemonModel>>> searchPokemonByName(
    String query,
  ) async {
    if (_allPokemonNames == null) {
      final namesResult = await apiClient.request(
        '/pokemon-species',
        queryParameters: {'limit': '1026', 'offset': '0'},
        onSuccess: (body) {
          final results = body['results'] as List<dynamic>;
          return results.map((e) => e['name'] as String).toList();
        },
      );
      if (namesResult.isLeft) {
        return Left(namesResult.left!);
      }
      _allPokemonNames = namesResult.rigth!;
    }

    final lowerQuery = query.toLowerCase();
    final matchedNames = _allPokemonNames!
        .where((name) => name.toLowerCase().startsWith(lowerQuery))
        .toList();

    if (matchedNames.isEmpty) {
      return const Rigth([]);
    }
    final futures = matchedNames
        .map(
          (name) => apiClient.request(
            '/pokemon/$name',
            onSuccess: (body) =>
                PokemonModel.fromJson(body as Map<String, dynamic>),
          ),
        )
        .toList();

    final pokemonList = await Future.wait(futures);
    final pokemons = <PokemonModel>[];
    for (final pokemon in pokemonList) {
      pokemon.fold((_) {}, pokemons.add);
    }

    return Rigth(pokemons);
  }

  @override
  Future<Either<Failure, List<PokemonModel>>> getPokemonByForm(
    PokemonForm form,
  ) async {
    final pokemonResult = await apiClient.request(
      '/pokemon-form',
      queryParameters: {'limit': '2000', 'offset': '1025'},
      onSuccess: (body) {
        final results = body['results'] as List<dynamic>;
        return results.map((e) => e['name'] as String).toList();
      },
    );

    if (pokemonResult.isLeft) {
      return Left(pokemonResult.left!);
    }

    final names = pokemonResult.rigth!;

    final filterNames = names
        .where((name) => name.contains(form.value))
        .toList();

    final futures = filterNames
        .map(
          (name) => apiClient.request(
            '/pokemon/$name',
            onSuccess: (body) =>
                PokemonModel.fromJson(body as Map<String, dynamic>),
          ),
        )
        .toList();

    final pokemonList = await Future.wait(futures);

    final pokemons = <PokemonModel>[];

    for (final pokemon in pokemonList) {
      pokemon.fold((_) {}, pokemons.add);
    }

    if (pokemons.isEmpty) {
      return Left(ServerFailure('No se cargaron'));
    }
    return Rigth(pokemons);
  }
}
