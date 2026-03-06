import 'package:atomic_ds_system_jd/atomic_ds_system_jd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_api_v1/domain/enums/pokemon_form.dart';
import 'package:pokemon_api_v1/presentation/providers/pokemons_region_provider.dart';

class PokemonFormScreen extends ConsumerWidget {
  final PokemonForm form;

  const PokemonFormScreen({super.key, required this.form});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonForm = ref.watch(pokemonByFormProvider(form));
    return Scaffold(
      appBar: AppBar(title: Text(form.label)),
      body: pokemonForm.when(
        data: (pokemons) {
          return Column(
            children: [
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
    );
  }
}
