import 'dart:async';

import 'package:atomic_ds_system_jd/atomic_ds_system_jd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_api_v1/presentation/providers/pokemon_search_provider.dart';

class PokemonSearchScreen extends ConsumerStatefulWidget {
  const PokemonSearchScreen({super.key});

  @override
  ConsumerState<PokemonSearchScreen> createState() =>
      _PokemonSearchScreenState();
}

class _PokemonSearchScreenState extends ConsumerState<PokemonSearchScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  Timer? _debounce;
  bool _isAppBarVisible = true;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchQueryProvider.notifier).state = value.trim();
    });
  }

  bool _onScrollNotification(UserScrollNotification notification) {
    if (notification.direction == ScrollDirection.reverse && _isAppBarVisible) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() => _isAppBarVisible = false);
    } else if (notification.direction == ScrollDirection.forward &&
        !_isAppBarVisible) {
      setState(() => _isAppBarVisible = true);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchPokemonProvider);
    final topPadding = MediaQuery.of(context).padding.top;

    final dsAppBar = DsSearchAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => context.pop('/pokedex'),
        color: DsColors.red,
      ),
      searchInput: DsSearchInput(
        controller: _searchController,
        focusNode: _searchFocusNode,
        autofocus: true,
        hintText: 'Buscar Pokemon...',
        onChanged: (value) {
          setState(() {
            _onSearchChanged(value);
          });
        },
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                  setState(() {});
                },
              )
            : null,
      ),
    );

    final appBarHeight = dsAppBar.preferredSize.height + topPadding;

    return Scaffold(
      body: NotificationListener<UserScrollNotification>(
        onNotification: _onScrollNotification,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isAppBarVisible ? appBarHeight : topPadding,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: SizedBox(
                height: appBarHeight,
                child: SafeArea(bottom: false, child: dsAppBar),
              ),
            ),
            const SizedBox(height: DsSpacing.xs),
            Expanded(
              child: searchState.when(
                data: (pokemons) {
                  if (_searchController.text.isEmpty) {
                    return Center(
                      child: Text('Escribe el nombre de un pokemon'),
                    );
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
            ),
          ],
        ),
      ),
    );
  }
}
