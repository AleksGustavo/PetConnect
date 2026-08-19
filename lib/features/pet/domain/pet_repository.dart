import 'pet.dart';

/// Interface do repositório de pets — a UI e os providers dependem desta
/// abstração, não do Firebase diretamente (ver docs/arquitetura.md).
abstract class PetRepository {
  /// Observa os pets pertencentes a [userId] (RF11). A implementação deve
  /// garantir que nenhum pet de outro tutor seja retornado (RF12).
  Stream<List<Pet>> watchPets(String userId);

  /// Observa um único pet pelo [petId] (RF15), emitindo `null` se não
  /// existir (ou tiver sido excluído).
  Stream<Pet?> watchPet(String petId);

  /// Cria um novo pet (RF10) e retorna o id gerado.
  Future<String> createPet(Pet pet);

  /// Atualiza os dados de um pet já cadastrado (RF13).
  Future<void> updatePet(Pet pet);

  /// Exclui um pet (RF14).
  Future<void> deletePet(String petId);
}
