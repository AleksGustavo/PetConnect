/// Status de uma consulta veterinária (RF28).
enum ConsultaStatus {
  agendada,
  realizada,
  cancelada;

  static ConsultaStatus fromValue(String value) {
    return ConsultaStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => ConsultaStatus.agendada,
    );
  }
}

/// Consulta veterinária agendada para um pet — subcoleção
/// `Pets/{petId}/consultas/{id}` (ver docs/modelo-dados-firestore.md, seção
/// "Proposta ainda não implementada no banco real").
class Consulta {
  const Consulta({
    required this.id,
    required this.data,
    required this.veterinario,
    required this.motivo,
    required this.status,
    this.horario,
  });

  final String id;

  /// Formato `dd/MM/yyyy`.
  final String data;

  /// Formato `HH:mm`, ou nulo se o horário não foi definido.
  final String? horario;
  final String veterinario;
  final String motivo;
  final ConsultaStatus status;

  factory Consulta.fromMap(String id, Map<String, dynamic> map) {
    return Consulta(
      id: id,
      data: map['data'] as String? ?? '',
      horario: map['horario'] as String?,
      veterinario: map['veterinario'] as String? ?? '',
      motivo: map['motivo'] as String? ?? '',
      status: ConsultaStatus.fromValue(map['status'] as String? ?? 'agendada'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'horario': horario,
      'veterinario': veterinario,
      'motivo': motivo,
      'status': status.name,
    };
  }

  Consulta copyWith({
    String? data,
    String? horario,
    String? veterinario,
    String? motivo,
    ConsultaStatus? status,
  }) {
    return Consulta(
      id: id,
      data: data ?? this.data,
      horario: horario ?? this.horario,
      veterinario: veterinario ?? this.veterinario,
      motivo: motivo ?? this.motivo,
      status: status ?? this.status,
    );
  }
}
