import 'usuario.dart';

/// Interface do repositório de usuário — a UI e os providers dependem
/// desta abstração, não do Firebase diretamente (ver docs/arquitetura.md).
///
/// Login social (Google/Facebook, RF04-A/RF04-B) fica para uma próxima
/// etapa; por ora só e-mail/senha.
abstract class UsuarioRepository {
  /// Observa o documento do usuário em `Usuarios/{uid}`, emitindo `null`
  /// se o documento não existir.
  Stream<Usuario?> watchUsuario(String uid);

  Future<void> signIn({required String email, required String password});

  Future<void> signUp({
    required String nome,
    required String email,
    required String password,
    required String telefone,
    required String dataNascimento,
  });

  Future<void> sendPasswordReset({required String email});

  Future<void> signOut();

  /// Edita nome, telefone e foto do tutor autenticado (RF08).
  Future<void> updateUsuario({
    required String nome,
    required String telefone,
    String? foto,
  });

  /// Exclui a conta do tutor autenticado (RF09): remove os pets (e as
  /// subcoleções de vacinas/histórico médico de cada um), o documento do
  /// tutor e o usuário no Firebase Auth.
  Future<void> deleteAccount();
}
