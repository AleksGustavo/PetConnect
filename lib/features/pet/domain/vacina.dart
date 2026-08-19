/// Registro de vacina de um pet — subcoleção `Pets/{petId}/vacinas/{id}`
/// (ver docs/modelo-dados-firestore.md, seção "Proposta ainda não
/// implementada no banco real").
class Vacina {
  const Vacina({
    required this.id,
    required this.nome,
    required this.dataAplicacao,
    this.proximaDose,
    this.veterinario,
    this.observacoes,
  });

  final String id;
  final String nome;

  /// Formato `dd/MM/yyyy`.
  final String dataAplicacao;

  /// Formato `dd/MM/yyyy`, ou nulo/vazio se não houver dose seguinte prevista.
  final String? proximaDose;
  final String? veterinario;
  final String? observacoes;

  factory Vacina.fromMap(String id, Map<String, dynamic> map) {
    return Vacina(
      id: id,
      nome: map['nome'] as String? ?? '',
      dataAplicacao: map['dataAplicacao'] as String? ?? '',
      proximaDose: map['proximaDose'] as String?,
      veterinario: map['veterinario'] as String?,
      observacoes: map['observacoes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'dataAplicacao': dataAplicacao,
      'proximaDose': proximaDose,
      'veterinario': veterinario,
      'observacoes': observacoes,
    };
  }

  Vacina copyWith({
    String? nome,
    String? dataAplicacao,
    String? proximaDose,
    String? veterinario,
    String? observacoes,
  }) {
    return Vacina(
      id: id,
      nome: nome ?? this.nome,
      dataAplicacao: dataAplicacao ?? this.dataAplicacao,
      proximaDose: proximaDose ?? this.proximaDose,
      veterinario: veterinario ?? this.veterinario,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}
