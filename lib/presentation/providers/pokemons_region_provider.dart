import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_api_v1/data/models/pokemon_model.dart';
import 'package:pokemon_api_v1/domain/enums/pokemon_form.dart';
import 'package:pokemon_api_v1/presentation/providers/pokemons_provider.dart';

final pokemonByFormProvider = FutureProvider.family<List<PokemonModel>, PokemonForm>(
  (ref, form) async {
    final repository = ref.watch(pokemonRespositoryProvider);
    final result = await repository.getPokemonByForm(form);
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (pokemons) => pokemons,
    );
  },
);