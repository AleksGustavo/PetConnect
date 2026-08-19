import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/firebase_usuario_repository.dart';
import '../../domain/usuario.dart';
import '../../domain/usuario_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final usuarioRepositoryProvider = Provider<UsuarioRepository>((ref) {
  return FirebaseUsuarioRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

/// Sessão do Firebase Auth (null = deslogado). Usado pelo guard de rotas.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// Documento do usuário logado em `Usuarios/{uid}`, já combinando com o
/// estado de autenticação — null enquanto deslogado ou se o documento
/// ainda não existir.
final currentUsuarioProvider = StreamProvider<Usuario?>((ref) async* {
  final auth = ref.watch(firebaseAuthProvider);
  final repository = ref.watch(usuarioRepositoryProvider);

  await for (final user in auth.authStateChanges()) {
    if (user == null) {
      yield null;
    } else {
      yield* repository.watchUsuario(user.uid);
    }
  }
});
