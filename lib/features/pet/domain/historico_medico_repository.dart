import 'historico_medico.dart';

/// Interface do repositório de histórico médico — a UI e os providers
/// dependem desta abstração, não do Firebase diretamente (ver
/// docs/arquitetura.md).
abstract class HistoricoMedicoRepository {
  /// Observa o histórico de um pet (RF25), em ordem cronológica.
  Stream<List<HistoricoMedico>> watchHistorico(String petId);

  /// Gera um id novo sem gravar nada no Firestore — usado para já ter um
  /// caminho estável no Storage antes de o registro existir, já que os
  /// anexos (RF24) são enviados antes de o registro ser salvo.
  String novoId(String petId);

  /// Registra uma entrada de histórico médico (RF24). [historico.id] deve
  /// vir de [novoId].
  Future<void> createHistorico(String petId, HistoricoMedico historico);

  /// Edita uma entrada de histórico médico (RF26).
  Future<void> updateHistorico(String petId, HistoricoMedico historico);

  /// Exclui uma entrada de histórico médico (RF26).
  Future<void> deleteHistorico(String petId, String historicoId);
}
