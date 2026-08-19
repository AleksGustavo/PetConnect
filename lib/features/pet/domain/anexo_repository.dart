import 'dart:typed_data';

/// Upload de anexos (RF24) ao Firebase Storage. Abstraído por bytes em vez
/// de `File`/`XFile` do image_picker para não acoplar a camada domain a um
/// plugin específico (ver docs/arquitetura.md) e continuar funcionando na
/// Web, onde `dart:io File` não existe.
abstract class AnexoRepository {
  /// Envia [bytes] para [path] no Storage e retorna a URL pública de
  /// download. Validação de tamanho/tipo é feita antes de chamar isto (ver
  /// docs/seguranca.md — "Validação de entrada").
  Future<String> upload({
    required String path,
    required Uint8List bytes,
    required String contentType,
  });

  /// Remove um anexo pela URL de download (usado ao excluir um registro de
  /// histórico ou remover um anexo individual antes de salvar).
  Future<void> delete(String url);
}
