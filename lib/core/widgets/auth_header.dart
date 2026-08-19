import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Cabeçalho com gradiente de marca, logo e padrão de patinhas, reaproveitado
/// nas telas de login, cadastro e recuperação de senha para manter a
/// identidade visual consistente entre elas.
///
/// O arquivo `assets/images/pawprints.png` precisa existir (PNG com fundo
/// transparente) para o padrão de patinhas aparecer — sem ele, a área some
/// silenciosamente (ver [_PawPrintsBackground]).
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, this.onBack});

  /// Quando não nulo, mostra uma seta de voltar (telas empilhadas sobre o
  /// login, como cadastro e esqueci-senha). O login, por ser a rota raiz,
  /// não passa esse callback.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, onBack != null ? 8 : 48, 24, 48),
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _PawPrintsBackground()),
            Column(
              children: [
                if (onBack != null)
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back, color: AppColors.textOnBrand),
                    ),
                  ),
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
                const SizedBox(height: 8),
                const Text(
                  'Conectando corações perdidos aos seus lares',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textOnBrand, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PawPrintsBackground extends StatelessWidget {
  const _PawPrintsBackground();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.15,
      child: Image.asset(
        'assets/images/pawprints.png',
        repeat: ImageRepeat.repeat,
        fit: BoxFit.none,
        alignment: Alignment.topLeft,
        // Some silenciosamente se o arquivo ainda não foi adicionado, em vez
        // de mostrar o ícone de erro padrão do Flutter por cima do header.
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}
