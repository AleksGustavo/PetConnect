/// Entrada de histórico médico de um pet — subcoleção
/// `Pets/{petId}/historicoMedico/{id}` (ver docs/modelo-dados-firestore.md,
/// seção "Proposta ainda não implementada no banco real").
class HistoricoMedico {
  const HistoricoMedico({
    required this.id,
    required this.data,
    required this.descricao,
    this.veterinario,
    this.anexos = const [],
  });

  final String id;

  /// Formato `dd/MM/yyyy`.
  final String data;
  final String descricao;
  final String? veterinario;

  /// URLs de arquivos no Firebase Storage (RF24 — "anexos como exames").
  final List<String> anexos;

  factory HistoricoMedico.fromMap(String id, Map<String, dynamic> map) {
    return HistoricoMedico(
      id: id,
      data: map['data'] as String? ?? '',
      descricao: map['descricao'] as String? ?? '',
      veterinario: map['veterinario'] as String?,
      anexos: (map['anexos'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'descricao': descricao,
      'veterinario': veterinario,
      'anexos': anexos,
    };
  }

  HistoricoMedico copyWith({
    String? data,
    String? descricao,
    String? veterinario,
    List<String>? anexos,
  }) {
    return HistoricoMedico(
      id: id,
      data: data ?? this.data,
      descricao: descricao ?? this.descricao,
      veterinario: veterinario ?? this.veterinario,
      anexos: anexos ?? this.anexos,
    );
  }
}
