import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_api_v1/core/network/api_client_provider.dart';
import 'package:pokemon_api_v1/data/models/pokemon_model.dart';
import 'package:pokemon_api_v1/data/repositories/pokemon_repository_impl.dart';
import 'package:pokemon_api_v1/domain/repositories/pokemon_respository.dart';
import 'package:pokemon_api_v1/domain/usecases/get_pokemon_usecase.dart';

final pokemonRespositoryProvider = Provider<PokemonRespository>((ref) {
  return PokemonRepositoryImpl(apiClientProvider);
});

final pokemonUsecaseProvider = Provider<GetPokemonUsecase>((ref) {
  return GetPokemonUsecase(ref.watch(pokemonRespositoryProvider));
});

final pokemonProvider = AsyncNotifierProvider<PokemonsNotifier, List<PokemonModel>>(
  PokemonsNotifier.new,
);

class PokemonsNotifier extends AsyncNotifier<List<PokemonModel>> {
  @override
  Future<List<PokemonModel>> build() => _fetchPokemons();

  Future<List<PokemonModel>> _fetchPokemons() async {
    final usecase = ref.read(pokemonUsecaseProvider);
    final result = await usecase.getPokemons();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (pokemons) => pokemons,
    );
  }
}
