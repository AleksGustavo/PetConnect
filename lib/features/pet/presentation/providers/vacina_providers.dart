import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../usuario/presentation/providers/auth_providers.dart';
import '../../data/firebase_vacina_repository.dart';
import '../../domain/vacina.dart';
import '../../domain/vacina_repository.dart';

final vacinaRepositoryProvider = Provider<VacinaRepository>((ref) {
  return FirebaseVacinaRepository(firestore: ref.watch(firestoreProvider));
});

/// Vacinas de um pet (RF21). `family` porque cada perfil de pet observa a
/// própria lista.
final vacinasProvider = StreamProvider.family<List<Vacina>, String>((ref, petId) {
  return ref.watch(vacinaRepositoryProvider).watchVacinas(petId);
});
