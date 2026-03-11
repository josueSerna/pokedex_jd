import 'package:atomic_ds_system_jd/atomic_ds_system_jd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_api_v1/presentation/providers/pokemons_provider.dart';

class PokedexScreen extends ConsumerWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonProvider);

    return Scaffold(
      appBar: DsCustomAppBar(
        showBackButton: true, 
        onBack: () => context.pop(),
        title: 'Pokedex',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pokedex/search'),
        child: Icon(Icons.search),
      ),
      body: state.when(
        data: (pokemons) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
                ref.read(pokemonProvider.notifier).loadMore();
              }
              return false;
            },
            child: Column(
              children: [
                const SizedBox(height: DsSpacing.xl),
                Expanded(
                  child: DsGridCard(
                    aspectRatio: 1.4,
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
