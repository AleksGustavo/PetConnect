import 'localizacao.dart';

/// Interface do repositório de localizações — a UI e os providers dependem
/// desta abstração, não do Firebase diretamente (ver docs/arquitetura.md).
abstract class LocalizacaoRepository {
  /// Observa os registros de localização de um pet (RF32), mais recentes
  /// primeiro.
  Stream<List<Localizacao>> watchLocalizacoes(String petId);

  /// Registra um avistamento (RF31/RF32).
  Future<void> createLocalizacao(String petId, Localizacao localizacao);
}
