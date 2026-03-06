import 'package:pokemon_api_v1/core/error/failure.dart';
import 'package:pokemon_api_v1/core/network/either.dart';
import 'package:pokemon_api_v1/data/models/pokemon_model.dart';
import 'package:pokemon_api_v1/domain/enums/pokemon_form.dart';
import 'package:pokemon_api_v1/domain/repositories/pokemon_respository.dart';

class GetPokemonFormUsecase {
  final PokemonRespository _pokemonRespository;

  GetPokemonFormUsecase(this._pokemonRespository);

  Future<Either<Failure, List<PokemonModel>>> getPokemonByForm(
    PokemonForm form,
  ) {
    return _pokemonRespository.getPokemonByForm(form);
  }
}
