import 'consulta.dart';

/// Interface do repositório de consultas — a UI e os providers dependem
/// desta abstração, não do Firebase diretamente (ver docs/arquitetura.md).
abstract class ConsultaRepository {
  /// Observa as consultas de um pet (RF28), em ordem cronológica.
  Stream<List<Consulta>> watchConsultas(String petId);

  /// Agenda uma nova consulta (RF27).
  Future<void> createConsulta(String petId, Consulta consulta);

  /// Edita uma consulta — inclui alterar dados/veterinário/motivo, cancelar
  /// ou marcar como realizada (RF29), sempre através do status.
  Future<void> updateConsulta(String petId, Consulta consulta);
}
