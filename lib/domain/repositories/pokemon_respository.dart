import 'package:pokemon_api_v1/core/error/failure.dart';
import 'package:pokemon_api_v1/core/network/either.dart';
import 'package:pokemon_api_v1/data/models/pokemon_model.dart';
import 'package:pokemon_api_v1/domain/enums/pokemon_form.dart';

abstract class PokemonRespository {
  Future<Either<Failure,List<PokemonModel>>> getPokemons({int limit = 20, int offset = 0});
  Future<Either<Failure, List<PokemonModel>>> getPokemonByForm(PokemonForm form);
}
