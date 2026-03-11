import 'package:atomic_ds_system_jd/atomic_ds_system_jd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: DsCustomAppBar(
        showBackButton: false,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),

          child: Column(
            children: [
              const SizedBox(height: DsSpacing.xl),
              Expanded(
                child: DsGridCard(
                  aspectRatio: 2.0,
                  children: [
                    DsCardMenu(
                      name: 'Pokedex',
                      color: Colors.red,
                      onTap: () => context.push('/pokedex'),
                    ),
                    DsCardMenu(
                      name: 'Megas',
                      color: Colors.lightBlueAccent.shade700,
                      onTap: () => context.push('/form/mega'),
                    ),
                    DsCardMenu(
                      name: 'Alola',
                      color: Colors.greenAccent,
                      onTap: () => context.push('/form/alola'),
                    ),
                    DsCardMenu(
                      name: 'Galar',
                      color: Colors.amber.shade200,
                      onTap: () => context.push('/form/galar'),
                    ),
                    DsCardMenu(
                      name: 'Gigamax',
                      color: Colors.deepOrange.shade200,
                      onTap: () => context.push('/form/gmax'),
                    ),
                    DsCardMenu(
                      name: 'Hisui',
                      color: Colors.deepPurple.shade200,
                      onTap: () => context.push('/form/hisui'),
                    ),
                    DsCardMenu(
                      name: 'Paldea',
                      color: Colors.brown.shade200,
                      onTap: () => context.push('/form/paldea'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
