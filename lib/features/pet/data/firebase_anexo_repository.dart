import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../domain/anexo_repository.dart';

class FirebaseAnexoRepository implements AnexoRepository {
  FirebaseAnexoRepository({required FirebaseStorage storage}) : _storage = storage;

  final FirebaseStorage _storage;

  @override
  Future<String> upload({
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final ref = _storage.ref(path);
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    return ref.getDownloadURL();
  }

  @override
  Future<void> delete(String url) async {
    await _storage.refFromURL(url).delete();
  }
}
