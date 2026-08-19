import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/firebase_anexo_repository.dart';
import '../../domain/anexo_repository.dart';

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

/// Upload/remoção de arquivos no Firebase Storage — usado tanto para anexos
/// de histórico médico (RF24) quanto para fotos de perfil (pet e tutor).
final anexoRepositoryProvider = Provider<AnexoRepository>((ref) {
  return FirebaseAnexoRepository(storage: ref.watch(firebaseStorageProvider));
});
