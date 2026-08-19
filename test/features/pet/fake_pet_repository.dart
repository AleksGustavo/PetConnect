import 'dart:async';

import 'package:pet_connect/features/pet/domain/pet.dart';
import 'package:pet_connect/features/pet/domain/pet_repository.dart';

/// Repositório em memória para testes de widget, sem depender de um
/// Firestore real (ver "Testes" em docs/arquitetura.md).
class FakePetRepository implements PetRepository {
  final Map<String, Pet> _store = {};
  final _changes = StreamController<void>.broadcast();
  int _nextId = 0;

  @override
  Stream<List<Pet>> watchPets(String userId) async* {
    yield _snapshot(userId);
    await for (final _ in _changes.stream) {
      yield _snapshot(userId);
    }
  }

  @override
  Stream<Pet?> watchPet(String petId) async* {
    yield _store[petId];
    await for (final _ in _changes.stream) {
      yield _store[petId];
    }
  }

  @override
  Future<String> createPet(Pet pet) async {
    final id = 'pet-${_nextId++}';
    _store[id] = Pet.fromMap(id, pet.toMap());
    _changes.add(null);
    return id;
  }

  @override
  Future<void> updatePet(Pet pet) async {
    _store[pet.id] = pet;
    _changes.add(null);
  }

  @override
  Future<void> deletePet(String petId) async {
    _store.remove(petId);
    _changes.add(null);
  }

  List<Pet> _snapshot(String userId) {
    final list = _store.values.where((pet) => pet.userId == userId).toList();
    list.sort((a, b) => a.nome.compareTo(b.nome));
    return list;
  }
}
