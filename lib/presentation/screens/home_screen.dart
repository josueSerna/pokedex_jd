import 'package:atomic_ds_system_jd/atomic_ds_system_jd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_api_v1/presentation/providers/pokemons_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Pokedex')),
      body: state.when(
        data: (pokemons) {
          return  NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
                ref.read(pokemonProvider.notifier).loadMore();
              }
              return false;
            },
            child: Column(
              children: [
                Expanded(
                  child: DsGridCard(
                    children: pokemons.map((pokemon) {
                      return DsCardItem(
                        name: pokemon.name,
                        number: pokemon.id.toString(),
                        imageUrl: pokemon.imageUrl,
                        types: pokemon.types,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, _) => Center(child: Text('Error')),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}