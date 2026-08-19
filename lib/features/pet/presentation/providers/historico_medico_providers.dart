import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../usuario/presentation/providers/auth_providers.dart';
import '../../data/firebase_anexo_repository.dart';
import '../../data/firebase_historico_medico_repository.dart';
import '../../domain/anexo_repository.dart';
import '../../domain/historico_medico.dart';
import '../../domain/historico_medico_repository.dart';

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

final historicoMedicoRepositoryProvider = Provider<HistoricoMedicoRepository>((ref) {
  return FirebaseHistoricoMedicoRepository(firestore: ref.watch(firestoreProvider));
});

final anexoRepositoryProvider = Provider<AnexoRepository>((ref) {
  return FirebaseAnexoRepository(storage: ref.watch(firebaseStorageProvider));
});

/// Histórico médico de um pet (RF25). `family` porque cada perfil de pet
/// observa a própria lista.
final historicoMedicoProvider = StreamProvider.family<List<HistoricoMedico>, String>((ref, petId) {
  return ref.watch(historicoMedicoRepositoryProvider).watchHistorico(petId);
});
