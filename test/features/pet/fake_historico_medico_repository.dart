import 'dart:async';

import 'package:pet_connect/core/utils/br_date.dart';
import 'package:pet_connect/features/pet/domain/historico_medico.dart';
import 'package:pet_connect/features/pet/domain/historico_medico_repository.dart';

/// Repositório em memória para testes de widget, sem depender de um
/// Firestore real (ver "Testes" em docs/arquitetura.md).
class FakeHistoricoMedicoRepository implements HistoricoMedicoRepository {
  final Map<String, Map<String, HistoricoMedico>> _store = {};
  final _changes = StreamController<void>.broadcast();
  int _nextId = 0;

  @override
  String novoId(String petId) => 'historico-${_nextId++}';

  @override
  Stream<List<HistoricoMedico>> watchHistorico(String petId) async* {
    yield _snapshot(petId);
    await for (final _ in _changes.stream) {
      yield _snapshot(petId);
    }
  }

  @override
  Future<void> createHistorico(String petId, HistoricoMedico historico) async {
    _store.putIfAbsent(petId, () => {})[historico.id] = historico;
    _changes.add(null);
  }

  @override
  Future<void> updateHistorico(String petId, HistoricoMedico historico) async {
    _store.putIfAbsent(petId, () => {})[historico.id] = historico;
    _changes.add(null);
  }

  @override
  Future<void> deleteHistorico(String petId, String historicoId) async {
    _store[petId]?.remove(historicoId);
    _changes.add(null);
  }

  List<HistoricoMedico> _snapshot(String petId) {
    final registros = (_store[petId] ?? {}).values.toList();
    registros.sort((a, b) {
      final dataA = parseBrDate(a.data);
      final dataB = parseBrDate(b.data);
      if (dataA == null || dataB == null) return 0;
      return dataA.compareTo(dataB);
    });
    return registros;
  }
}
