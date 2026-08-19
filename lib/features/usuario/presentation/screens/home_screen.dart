import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../pet/presentation/providers/pet_providers.dart';
import '../../../pet/presentation/widgets/pet_card.dart';
import '../providers/auth_providers.dart';

/// Home do tutor: lista os pets vinculados à conta (RF11), com atalho para
/// cadastrar um novo (RF10), acessar configurações e sair.
///
/// A Home é a raiz da navegação autenticada — tanto o botão físico/gesto de
/// voltar quanto o ícone de logout pedem confirmação antes de agir, para
/// evitar fechar o app ou encerrar a sessão sem querer.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<bool> _confirmar(BuildContext context, {required String titulo, required String mensagem, required String confirmar}) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmar),
          ),
        ],
      ),
    );
    return confirmou ?? false;
  }

  Future<void> _handleSair(BuildContext context, WidgetRef ref) async {
    final confirmou = await _confirmar(
      context,
      titulo: 'Sair da conta',
      mensagem: 'Tem certeza que deseja sair da sua conta?',
      confirmar: 'Sair',
    );
    if (confirmou) await ref.read(usuarioRepositoryProvider).signOut();
  }

  Future<void> _handleVoltar(BuildContext context) async {
    final confirmou = await _confirmar(
      context,
      titulo: 'Sair do app',
      mensagem: 'Tem certeza que deseja sair do PetConnect?',
      confirmar: 'Sair',
    );
    if (confirmou) SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuarioAsync = ref.watch(currentUsuarioProvider);
    final petsAsync = ref.watch(petsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleVoltar(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text('Meus pets', style: TextStyle(color: AppColors.textPrimary)),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
              tooltip: 'Configurações',
              onPressed: () => context.push('/configuracoes'),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.textPrimary),
              tooltip: 'Sair',
              onPressed: () => _handleSair(context, ref),
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
      ),
    );
  }
}
