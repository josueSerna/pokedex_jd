import 'package:atomic_ds_system_jd/atomic_ds_system_jd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_api_v1/core/utils/scroll_behavior_utils.dart';
import 'package:pokemon_api_v1/domain/enums/pokemon_form.dart';
import 'package:pokemon_api_v1/presentation/providers/pokemons_region_provider.dart';

class PokemonFormScreen extends ConsumerWidget {
  final PokemonForm form;

  const PokemonFormScreen({super.key, required this.form});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonForm = ref.watch(pokemonByFormProvider(form));
    final isAppBarVisible = ref.watch(
      appBarVisibilityProvider('form_${form.name}'),
    );
    final scrollHandler = AppBarScrollHandler(
      ref,
      screenKey: 'form_${form.name}',
    );
    final topPadding = MediaQuery.of(context).padding.top;

    final appBar = DsCustomAppBar(
      showBackButton: true,
      title: form.label,
      onBack: () => context.pop(),
    );

    final appBarHeight = appBar.preferredSize.height + topPadding;

    return Scaffold(
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
            const SizedBox(height: DsSpacing.xxs),
            Expanded(
              child: pokemonForm.when(
                data: (pokemons) {
                  return Column(
                    children: [
                      const SizedBox(height: DsSpacing.xs),
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
