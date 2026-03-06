import 'package:go_router/go_router.dart';
import 'package:pokemon_api_v1/domain/enums/pokemon_form.dart';
import 'package:pokemon_api_v1/presentation/screens/home_screen.dart';
import 'package:pokemon_api_v1/presentation/screens/pokedex_screen.dart';
import 'package:pokemon_api_v1/presentation/screens/pokemon_form_screen.dart';
import 'package:pokemon_api_v1/presentation/screens/pokemon_search_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/pokedex',
      builder: (context, state) => const PokedexScreen(),
      routes: [
        GoRoute(
          path: 'search',
          builder: (context, state) => const PokemonSearchScreen(),
        )
      ]
    ),
    GoRoute(
      path: '/form/:type',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        final form = PokemonFormX.fromRoute(type);
        return PokemonFormScreen(form: form!);
      },
    ),
  ],
);
