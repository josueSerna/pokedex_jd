import 'dart:async';

import 'package:atomic_ds_system_jd/atomic_ds_system_jd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_api_v1/presentation/providers/pokemon_search_provider.dart';

class PokemonSearchScreen extends ConsumerStatefulWidget {
  const PokemonSearchScreen({super.key});

  @override
  ConsumerState<PokemonSearchScreen> createState() =>
      _PokemonSearchScreenState();
}

class _PokemonSearchScreenState extends ConsumerState<PokemonSearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchQueryProvider.notifier).state = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchPokemonProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Buscar pokemon...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {});
            _onSearchChanged(value);
          },
        ),
      ),
      body: searchState.when(
        data: (pokemons) {
          if (_searchController.text.isEmpty) {
            return Center(child: Text('Escribe el nombre de un pokemon'));
          }
          return DsGridCard(
            aspectRatio: 1.4,
            children: pokemons.map((pokemon) {
              return DsCardItem(
                name: pokemon.name,
                number: pokemon.id.toString(),
                imageUrl: pokemon.imageUrl,
                types: pokemon.types,
              );
            }).toList(),
          );
        },
        error: (error, _) => Center(child: Text('Error al buscar')),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
