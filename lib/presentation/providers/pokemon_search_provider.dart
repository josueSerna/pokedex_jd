import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pokemon_api_v1/data/models/pokemon_model.dart';
import 'package:pokemon_api_v1/domain/usecases/get_pokemon_by_search_usecase.dart';
import 'package:pokemon_api_v1/presentation/providers/pokemons_provider.dart';

final searchPokemonUsecaseProvider = Provider<GetPokemonBySearchUsecase>((ref) {
  return GetPokemonBySearchUsecase(ref.watch(pokemonRespositoryProvider));
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchPokemonProvider = FutureProvider<List<PokemonModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);

  if (query.isEmpty) return [];

  final usecase = ref.read(searchPokemonUsecaseProvider);
  final result = await usecase(query);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (pokemons) => pokemons,
  );
});
