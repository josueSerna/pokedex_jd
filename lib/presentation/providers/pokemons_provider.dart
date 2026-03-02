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

final pokemonProvider =
    AsyncNotifierProvider<PokemonsNotifier, List<PokemonModel>>(
      PokemonsNotifier.new,
    );

class PokemonsNotifier extends AsyncNotifier<List<PokemonModel>> {
  static const int _limit = 50;
  int _offset = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  @override
  Future<List<PokemonModel>> build() {
    _offset = 0;
    _hasMore = true;
    return _fetchPokemons();
  }

  Future<List<PokemonModel>> _fetchPokemons() async {
    final usecase = ref.read(pokemonUsecaseProvider);
    final result = await usecase.getPokemons(limit: _limit, offset: _offset);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (pokemons) => pokemons,
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    _offset += _limit;

    try {
      final usecase = ref.read(pokemonUsecaseProvider);
      final result = await usecase.getPokemons(limit: _limit, offset: _offset);

      result.fold(
        (failure) {
          _offset -= _limit;
        },
        (newPokemons) {
          if (newPokemons.isEmpty) {
            _hasMore = false;
          } else {
            final current = state.value ?? [];
            state = AsyncData([...current, ...newPokemons]);
          }
        },
      );
    } catch (_) {
      _offset -= _limit;
    } finally {
      _isLoadingMore = false;
    }
  }
}
