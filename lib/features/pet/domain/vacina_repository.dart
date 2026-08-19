import 'vacina.dart';

/// Interface do repositório de vacinas — a UI e os providers dependem desta
/// abstração, não do Firebase diretamente (ver docs/arquitetura.md).
abstract class VacinaRepository {
  /// Observa as vacinas de um pet (RF21), em ordem cronológica.
  Stream<List<Vacina>> watchVacinas(String petId);

  /// Registra uma vacina aplicada (RF20).
  Future<void> createVacina(String petId, Vacina vacina);

  /// Edita um registro de vacina (RF22).
  Future<void> updateVacina(String petId, Vacina vacina);

  /// Exclui um registro de vacina (RF22).
  Future<void> deleteVacina(String petId, String vacinaId);
}
