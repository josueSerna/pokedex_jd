import 'package:atomic_ds_system_jd/atomic_ds_system_jd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_api_v1/core/utils/scroll_behavior_utils.dart';
import 'package:pokemon_api_v1/presentation/providers/pokemons_provider.dart';

class PokedexScreen extends ConsumerWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonProvider);
    final isAppBarVisible = ref.watch(appBarVisibilityProvider('pokedex'));
    final scrollHandler = AppBarScrollHandler(ref, screenKey: 'pokedex');
    final topPadding = MediaQuery.of(context).padding.top;

    final appBar = DsCustomAppBar(
      showBackButton: true,
      onBack: () => context.pop(),
      title: 'Pokedex',
    );

    final appBarHeight = appBar.preferredSize.height + topPadding;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pokedex/search'),
        child: Icon(Icons.search),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: scrollHandler.handleScrollNotification,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isAppBarVisible ? appBarHeight : topPadding,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: SizedBox(
                height: appBarHeight,
                child: SafeArea(bottom: false, child: appBar),
              ),
            ),
            const SizedBox(height: DsSpacing.md),
            Expanded(
              child: state.when(
                data: (pokemons) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200) {
                        ref.read(pokemonProvider.notifier).loadMore();
                      }
                      return false;
                    },
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
                  );
                },
                error: (error, _) => Center(child: Text('Error')),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
