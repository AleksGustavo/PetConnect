import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/auth_error_translator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_header.dart';
import '../../../usuario/presentation/providers/auth_providers.dart';

class CadastroScreen extends ConsumerStatefulWidget {
  const CadastroScreen({super.key});

  @override
  ConsumerState<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends ConsumerState<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _handleCadastro() async {
    setState(() => _error = null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_senhaController.text != _confirmarSenhaController.text) {
      setState(() => _error = 'As senhas não coincidem.');
      return;
    }

    setState(() => _submitting = true);

    try {
      await ref.read(usuarioRepositoryProvider).signUp(
            nome: _nomeController.text.trim(),
            email: _emailController.text.trim(),
            password: _senhaController.text,
            telefone: _telefoneController.text.trim(),
            // Data de nascimento não é mais pedida no cadastro — fica para
            // a edição de perfil (RF08), mantendo o formulário curto.
            dataNascimento: '',
          );
      // Navegação para /home é feita pelo redirect do go_router.
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _error = translateAuthError(e.code));
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Não foi possível completar a operação. Tente novamente.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(onBack: () => context.pop()),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Crie sua conta',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Cadastre seus dados para começar a cuidar e proteger seus pets.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 24),
                      const _FieldLabel('Nome completo'),
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(hintText: 'Ex: Maria Silva'),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty) ? 'Informe seu nome.' : null,
                      ),
                      const SizedBox(height: 16),
                      const _FieldLabel('E-mail'),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: 'seu@email.com'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Informe seu e-mail.';
                          if (!value.contains('@')) return 'E-mail inválido.';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const _FieldLabel('Telefone'),
                      TextFormField(
                        controller: _telefoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(hintText: '(00) 00000-000'),
                      ),
                      const SizedBox(height: 16),
                      const _FieldLabel('Senha'),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: !_senhaVisivel,
                        decoration: InputDecoration(
                          hintText: 'Mínimo 8 caracteres',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _senhaVisivel ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                          ),
                        ),
                        validator: (value) => (value == null || value.length < 8)
                            ? 'Mínimo de 8 caracteres.'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      const _FieldLabel('Confirmar senha'),
                      TextFormField(
                        controller: _confirmarSenhaController,
                        obscureText: !_confirmarSenhaVisivel,
                        decoration: InputDecoration(
                          hintText: 'Repita a senha',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmarSenhaVisivel
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () =>
                                setState(() => _confirmarSenhaVisivel = !_confirmarSenhaVisivel),
                          ),
                        ),
                        validator: (value) =>
                            (value == null || value.isEmpty) ? 'Confirme sua senha.' : null,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: const TextStyle(color: AppColors.error, fontSize: 13),
                        ),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submitting ? null : _handleCadastro,
                        child: _submitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textOnBrand,
                                ),
                              )
                            : const Text('CRIAR CONTA'),
                      ),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
    );
  }
}
