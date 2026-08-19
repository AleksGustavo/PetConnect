/// Registro de localização/avistamento de um pet (RF31, RF32) — subcoleção
/// `Pets/{petId}/localizacoes/{id}`.
///
/// Estrutura definida do zero para esta fase: a coleção `Localizacoes` que
/// já existia no Firestore real nunca teve seus campos compartilhados (ver
/// docs/modelo-dados-firestore.md), então este modelo não tenta reconciliar
/// com ela — é uma proposta nova, como subcoleção do próprio pet.
class Localizacao {
  const Localizacao({
    required this.id,
    required this.data,
    required this.descricao,
    this.contatoReportante,
  });

  final String id;

  /// Formato `dd/MM/yyyy`.
  final String data;

  /// Onde/como o pet foi visto (texto livre — sem seletor de mapa nesta
  /// fase, para não introduzir uma dependência nova de geolocalização).
  final String descricao;

  /// Contato de quem reportou (telefone/nome), opcional.
  final String? contatoReportante;

  factory Localizacao.fromMap(String id, Map<String, dynamic> map) {
    return Localizacao(
      id: id,
      data: map['data'] as String? ?? '',
      descricao: map['descricao'] as String? ?? '',
      contatoReportante: map['contatoReportante'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'descricao': descricao,
      'contatoReportante': contatoReportante,
    };
  }
}
