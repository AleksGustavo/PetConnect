import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../usuario/presentation/providers/auth_providers.dart';
import '../../domain/pet.dart';
import '../providers/pet_providers.dart';

/// Perfil de um único pet (RF15), com atalhos para editar (RF13) e excluir
/// (RF14). Só mostra dados se o pet pertencer ao tutor autenticado — RF12,
/// reforçado aqui além das regras de segurança do Firestore.
class PetDetailScreen extends ConsumerWidget {
  const PetDetailScreen({super.key, required this.petId});

  final String petId;

  Future<void> _confirmarExclusao(BuildContext context, WidgetRef ref, Pet pet) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir pet'),
        content: Text('Tem certeza que deseja excluir ${pet.nome}? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    await ref.read(petRepositoryProvider).deletePet(pet.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider(petId));
    final uid = ref.watch(currentUsuarioProvider).valueOrNull?.id;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: petAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(
            child: Text('Não foi possível carregar este pet.', style: TextStyle(color: AppColors.error)),
          ),
          data: (pet) {
            if (pet == null || pet.userId != uid) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Pet não encontrado.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: AppColors.surface,
                      backgroundImage: pet.foto != null ? NetworkImage(pet.foto!) : null,
                      child: pet.foto == null
                          ? const Icon(Icons.pets, size: 48, color: AppColors.brandMedium)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pet.nome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _InfoTile(label: 'Espécie', value: pet.especie),
                  _InfoTile(label: 'Raça', value: pet.raca),
                  _InfoTile(label: 'Cor', value: pet.cor),
                  _InfoTile(label: 'Gênero', value: pet.genero),
                  _InfoTile(label: 'Porte', value: pet.porte),
                  _InfoTile(label: 'Peso', value: pet.peso),
                  _InfoTile(label: 'Data de nascimento', value: pet.dataNascimento),
                  _InfoTile(
                    label: 'Vacinado',
                    value: pet.vacinado ? 'Sim' : 'Não',
                    valueColor: pet.vacinado ? Colors.green : AppColors.error,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/pet/${pet.id}/editar', extra: pet),
                    icon: const Icon(Icons.edit),
                    label: const Text('EDITAR'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _confirmarExclusao(context, ref, pet),
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    label: const Text('EXCLUIR', style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.textMuted)),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
