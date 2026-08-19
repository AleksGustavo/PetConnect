import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/usuario.dart';
import '../domain/usuario_repository.dart';

class FirebaseUsuarioRepository implements UsuarioRepository {
  FirebaseUsuarioRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usuarios =>
      _firestore.collection('Usuarios');

  @override
  Stream<Usuario?> watchUsuario(String uid) {
    return _usuarios.doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (!doc.exists || data == null) return null;
      return Usuario.fromMap(doc.id, data);
    });
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUp({
    required String nome,
    required String email,
    required String password,
    required String telefone,
    required String dataNascimento,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;

    // usuarioID reaproveita o uid por ora — a modelagem original tinha um
    // UUID separado cujo uso ainda não foi confirmado (ver
    // docs/modelo-dados-firestore.md).
    await _usuarios.doc(uid).set({
      'usuarioID': uid,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'dataNascimento': dataNascimento,
      'genero': '',
      'foto': null,
    });
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
