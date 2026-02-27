import 'package:pokemon_api_v1/core/error/failure.dart';
import 'package:pokemon_api_v1/core/network/api_client.dart';
import 'package:pokemon_api_v1/core/network/either.dart';
import 'package:pokemon_api_v1/data/models/pokemon_model.dart';
import 'package:pokemon_api_v1/domain/repositories/pokemon_respository.dart';

class PokemonRepositoryImpl implements PokemonRespository {
  final ApiClient apiClient;

  PokemonRepositoryImpl(this.apiClient);

  @override
  Future<Either<Failure, List<PokemonModel>>> getPokemons({
    int limit = 50,
    int offset = 0,
  }) async {
    // final url = 'https://pokeapi.co/api/v2/';
    final pokemonResult = await apiClient.request(
      '/pokemon',
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
}
