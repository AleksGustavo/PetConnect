import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // TODO(auth): ligar ao UsuarioRepository (Firebase Auth) quando estiver
    // disponível — por ora só evita duplo toque enquanto não há lógica real.
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Transform.translate(
                  offset: const Offset(0, -32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _LoginCard(
                        emailController: _emailController,
                        senhaController: _senhaController,
                        submitting: _submitting,
                        onSubmit: _handleLogin,
                        onForgotPassword: () => context.push('/esqueci-senha'),
                      ),
                      const SizedBox(height: 24),
                      const _SocialLoginRow(),
                      const SizedBox(height: 24),
                      _SignUpPrompt(onTap: () => context.push('/cadastro')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            // TODO(design): substituir pelo ícone/ilustração real do
            // PetConnect (cachorro + gato em formato de pin) quando o
            // asset for exportado do layout.
            child: const Icon(
              Icons.pets,
              size: 72,
              color: AppColors.brandDark,
            ),
          ),
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
            style: TextStyle(
              color: AppColors.textOnBrand,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.emailController,
    required this.senhaController,
    required this.submitting,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  final TextEditingController emailController;
  final TextEditingController senhaController;
  final bool submitting;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandDark.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Login',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'E-mail:'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: senhaController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Senha:'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: submitting ? null : onSubmit,
            child: submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textOnBrand,
                    ),
                  )
                : const Text('ENTRAR'),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: onForgotPassword,
              child: const Text(
                'Esqueceu a senha?',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialLoginRow extends StatelessWidget {
  const _SocialLoginRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO(auth): ligar ao UsuarioRepository.signInWithGoogle()
            },
            icon: const Icon(Icons.g_mobiledata, size: 28),
            label: const Text('Google'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO(auth): ligar ao UsuarioRepository.signInWithFacebook()
            },
            icon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
            label: const Text('Facebook'),
          ),
        ),
      ],
    );
  }
}

class _SignUpPrompt extends StatelessWidget {
  const _SignUpPrompt({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Wrap (em vez de Row) evita overflow em telas estreitas: se não
    // couber na largura disponível, o link quebra para a linha de baixo
    // em vez de vazar pela borda da tela.
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        const Text(
          'Não tem uma conta? ',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Cadastre-se',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
