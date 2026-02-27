import 'package:pokemon_api_v1/core/error/failure.dart';
import 'package:pokemon_api_v1/core/network/either.dart';
import 'package:pokemon_api_v1/data/models/pokemon_model.dart';
import 'package:pokemon_api_v1/domain/repositories/pokemon_respository.dart';

class GetPokemonUsecase {
  PokemonRespository _pokemonRespository;

  GetPokemonUsecase(this._pokemonRespository);

  Future<Either<Failure, List<PokemonModel>>> getPokemons({
    int limit = 50,
    int offset = 0,
  }) {
    return _pokemonRespository.getPokemons( limit: limit, offset: offset);
  }
}
