import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/auth_error_translator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../usuario/presentation/providers/auth_providers.dart';

/// Cadastro pede só o essencial (nome, e-mail, senha) — telefone, data de
/// nascimento, gênero e foto ficam para a edição de perfil (RF08), evitando
/// um formulário longo logo de cara (RNF07).
class CadastroScreen extends ConsumerStatefulWidget {
  const CadastroScreen({super.key});

  @override
  ConsumerState<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends ConsumerState<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Criar conta', style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(hintText: 'Nome:'),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Informe seu nome.' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'E-mail:'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Informe seu e-mail.';
                    if (!value.contains('@')) return 'E-mail inválido.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Senha:'),
                  validator: (value) => (value == null || value.length < 6)
                      ? 'Mínimo de 6 caracteres.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmarSenhaController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Confirmar senha:'),
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
      ),
    );
  }
}
