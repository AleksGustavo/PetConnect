import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../usuario/presentation/providers/auth_providers.dart';
import '../../data/firebase_historico_medico_repository.dart';
import '../../domain/historico_medico.dart';
import '../../domain/historico_medico_repository.dart';

final historicoMedicoRepositoryProvider = Provider<HistoricoMedicoRepository>((ref) {
  return FirebaseHistoricoMedicoRepository(firestore: ref.watch(firestoreProvider));
});

/// Histórico médico de um pet (RF25). `family` porque cada perfil de pet
/// observa a própria lista.
final historicoMedicoProvider = StreamProvider.family<List<HistoricoMedico>, String>((ref, petId) {
  return ref.watch(historicoMedicoRepositoryProvider).watchHistorico(petId);
});
