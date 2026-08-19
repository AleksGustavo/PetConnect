import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../usuario/presentation/providers/auth_providers.dart';

/// Tela de carregamento exibida ao abrir o app, antes de decidir para onde
/// navegar (login ou Home, dependendo da sessão — RF06). Sem ela, a
/// primeira tela pode "piscar" para o login por uma fração de segundo
/// enquanto o Firebase Auth ainda está resolvendo a sessão salva.
///
/// Tempo mínimo de exibição: 2,5s — o suficiente pra marca ser reconhecida
/// sem irritar quem já usa o app no dia a dia (referência comum para splash
/// screens é 2-3s).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decidirDestino();
  }

  Future<void> _decidirDestino() async {
    final tempoMinimo = Future.delayed(const Duration(milliseconds: 2500));
    final usuario = await ref.read(authStateChangesProvider.future);
    await tempoMinimo;

    if (!mounted) return;
    context.go(usuario != null ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.brandGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 160, height: 160),
              const SizedBox(height: 24),
              const Text(
                'PetConnect',
                style: TextStyle(
                  color: AppColors.textOnBrand,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
