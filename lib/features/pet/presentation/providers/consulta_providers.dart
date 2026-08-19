import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../usuario/presentation/providers/auth_providers.dart';
import '../../data/firebase_consulta_repository.dart';
import '../../domain/consulta.dart';
import '../../domain/consulta_repository.dart';

final consultaRepositoryProvider = Provider<ConsultaRepository>((ref) {
  return FirebaseConsultaRepository(firestore: ref.watch(firestoreProvider));
});

/// Consultas de um pet (RF28). `family` porque cada perfil de pet observa a
/// própria lista.
final consultasProvider = StreamProvider.family<List<Consulta>, String>((ref, petId) {
  return ref.watch(consultaRepositoryProvider).watchConsultas(petId);
});
