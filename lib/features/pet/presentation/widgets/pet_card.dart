import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/pet.dart';

class PetCard extends StatelessWidget {
  const PetCard({super.key, required this.pet, required this.onTap});

  final Pet pet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.background,
                backgroundImage: pet.foto != null ? NetworkImage(pet.foto!) : null,
                child: pet.foto == null
                    ? const Icon(Icons.pets, color: AppColors.brandMedium)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [pet.especie, pet.raca].where((s) => s.isNotEmpty).join(' · '),
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(
                pet.vacinado ? Icons.verified : Icons.error_outline,
                color: pet.vacinado ? Colors.green : AppColors.error,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
