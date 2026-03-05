import 'package:go_router/go_router.dart';
import 'package:pokemon_api_v1/presentation/screens/home_screen.dart';
import 'package:pokemon_api_v1/presentation/screens/megas_screen.dart';
import 'package:pokemon_api_v1/presentation/screens/pokedex_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', 
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/pokedex', 
      builder: (context, state) => const PokedexScreen(),
    ),
    GoRoute(
      path: '/mega',
      builder: (context, state) => const MegasScreen()
    )
  ]
);
