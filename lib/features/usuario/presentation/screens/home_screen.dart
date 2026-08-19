import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';

/// Placeholder da Home — lista de pets (RF11), criar pet e configurações
/// de conta entram em uma próxima etapa. Por ora, confirma que o login
/// funcionou e permite sair.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuarioAsync = ref.watch(currentUsuarioProvider);

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
      body: SafeArea(
        child: Center(
          child: usuarioAsync.when(
            data: (usuario) => Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    usuario != null ? 'Bem-vindo, ${usuario.nome}!' : 'Bem-vindo!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (usuario != null) ...[
                    const SizedBox(height: 8),
                    Text(usuario.email, style: const TextStyle(color: AppColors.textMuted)),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'Lista de pets — em breve',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text(
              'Não foi possível carregar seus dados.',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ),
      ),
    );
  }
}
