import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../usuario/presentation/providers/auth_providers.dart';
import '../../data/firebase_localizacao_repository.dart';
import '../../domain/localizacao.dart';
import '../../domain/localizacao_repository.dart';

final localizacaoRepositoryProvider = Provider<LocalizacaoRepository>((ref) {
  return FirebaseLocalizacaoRepository(firestore: ref.watch(firestoreProvider));
});

/// Registros de localização de um pet (RF32). `family` porque cada perfil
/// de pet observa a própria lista.
final localizacoesProvider = StreamProvider.family<List<Localizacao>, String>((ref, petId) {
  return ref.watch(localizacaoRepositoryProvider).watchLocalizacoes(petId);
});
