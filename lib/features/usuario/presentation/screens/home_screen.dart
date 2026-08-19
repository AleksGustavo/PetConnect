import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../pet/presentation/providers/pet_providers.dart';
import '../../../pet/presentation/widgets/pet_card.dart';
import '../providers/auth_providers.dart';

/// Home do tutor: lista os pets vinculados à conta (RF11), com atalho para
/// cadastrar um novo (RF10) e permitir sair.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuarioAsync = ref.watch(currentUsuarioProvider);
    final petsAsync = ref.watch(petsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Meus pets', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textPrimary),
            tooltip: 'Sair',
            onPressed: () => ref.read(usuarioRepositoryProvider).signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pet/novo'),
        backgroundColor: AppColors.brandDark,
        tooltip: 'Cadastrar pet',
        child: const Icon(Icons.add, color: AppColors.textOnBrand),
      ),
      body: SafeArea(
        child: usuarioAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(
            child: Text(
              'Não foi possível carregar seus dados.',
              style: TextStyle(color: AppColors.error),
            ),
          ),
          data: (usuario) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Text(
                  usuario != null ? 'Bem-vindo, ${usuario.nome}!' : 'Bem-vindo!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: petsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(
                    child: Text(
                      'Não foi possível carregar seus pets.',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                  data: (pets) {
                    if (pets.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'Você ainda não cadastrou nenhum pet.\nToque em "+" para começar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 96),
                      itemCount: pets.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final pet = pets[index];
                        return PetCard(
                          pet: pet,
                          onTap: () => context.push('/pet/${pet.id}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
