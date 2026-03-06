import 'package:pokemon_api_v1/core/error/failure.dart';
import 'package:pokemon_api_v1/core/network/either.dart';
import 'package:pokemon_api_v1/data/models/pokemon_model.dart';
import 'package:pokemon_api_v1/domain/repositories/pokemon_respository.dart';

class GetPokemonBySearchUsecase {
  final PokemonRespository _pokemonRespository;

  GetPokemonBySearchUsecase(this._pokemonRespository);

  Future<Either<Failure, List<PokemonModel>>> call(
    String query,
  ) {
    return _pokemonRespository.searchPokemonByName(query);
  }
}
