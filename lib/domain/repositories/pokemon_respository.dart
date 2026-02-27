import 'package:pokemon_api_v1/core/error/failure.dart';
import 'package:pokemon_api_v1/core/network/either.dart';
import 'package:pokemon_api_v1/data/models/pokemon_model.dart';

abstract class PokemonRespository {
  Future<Either<Failure,List<PokemonModel>>> getPokemons({int limit = 50, int offset = 0});
}
