import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/br_date.dart';
import '../../../usuario/presentation/providers/auth_providers.dart';
import '../../domain/pet.dart';
import '../providers/pet_providers.dart';

const _generos = ['Macho', 'Fêmea'];
const _portes = ['Pequeno', 'Médio', 'Grande'];

/// Formulário de criar (RF10) ou editar (RF13) um pet. Sem [pet], é criação;
/// com [pet], os campos vêm preenchidos para edição.
class PetFormScreen extends ConsumerStatefulWidget {
  const PetFormScreen({super.key, this.pet});

  final Pet? pet;

  bool get isEditing => pet != null;

  @override
  ConsumerState<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends ConsumerState<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nomeController = TextEditingController(text: widget.pet?.nome ?? '');
  late final _racaController = TextEditingController(text: widget.pet?.raca ?? '');
  late final _corController = TextEditingController(text: widget.pet?.cor ?? '');
  late final _especieController = TextEditingController(text: widget.pet?.especie ?? '');
  late final _pesoController = TextEditingController(text: widget.pet?.peso ?? '');
  late final _dataNascimentoController =
      TextEditingController(text: widget.pet?.dataNascimento ?? '');

  late String _genero = widget.pet?.genero.isNotEmpty == true ? widget.pet!.genero : _generos.first;
  late String _porte = widget.pet?.porte.isNotEmpty == true ? widget.pet!.porte : _portes.first;
  late bool _vacinado = widget.pet?.vacinado ?? false;

  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _nomeController.dispose();
    _racaController.dispose();
    _corController.dispose();
    _especieController.dispose();
    _pesoController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  Future<void> _pickDataNascimento() async {
    final initial = parseBrDate(_dataNascimentoController.text) ?? DateTime(2020);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dataNascimentoController.text = formatBrDate(picked);
    }
  }

  Future<void> _handleSalvar() async {
    setState(() => _error = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final uid = ref.read(currentUsuarioProvider).valueOrNull?.id;
    if (uid == null) return;

    setState(() => _submitting = true);

    final repository = ref.read(petRepositoryProvider);
    final existing = widget.pet;

    try {
      if (existing == null) {
        final novoPet = Pet(
          id: '',
          userId: uid,
          nome: _nomeController.text.trim(),
          especie: _especieController.text.trim(),
          raca: _racaController.text.trim(),
          cor: _corController.text.trim(),
          genero: _genero,
          porte: _porte,
          peso: _pesoController.text.trim(),
          dataNascimento: _dataNascimentoController.text.trim(),
          vacinado: _vacinado,
        );
        await repository.createPet(novoPet);
      } else {
        await repository.updatePet(existing.copyWith(
          nome: _nomeController.text.trim(),
          especie: _especieController.text.trim(),
          raca: _racaController.text.trim(),
          cor: _corController.text.trim(),
          genero: _genero,
          porte: _porte,
          peso: _pesoController.text.trim(),
          dataNascimento: _dataNascimentoController.text.trim(),
          vacinado: _vacinado,
        ));
      }
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Não foi possível salvar o pet. Tente novamente.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          widget.isEditing ? 'Editar pet' : 'Novo pet',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(hintText: 'Nome:'),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Informe o nome do pet.' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _especieController,
                  decoration: const InputDecoration(hintText: 'Espécie (ex: Cachorro, Gato):'),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Informe a espécie.' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _racaController,
                  decoration: const InputDecoration(hintText: 'Raça:'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _corController,
                  decoration: const InputDecoration(hintText: 'Cor:'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _genero,
                  decoration: const InputDecoration(hintText: 'Gênero:'),
                  items: _generos
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) => setState(() => _genero = value ?? _genero),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _porte,
                  decoration: const InputDecoration(hintText: 'Porte:'),
                  items: _portes
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (value) => setState(() => _porte = value ?? _porte),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pesoController,
                  decoration: const InputDecoration(hintText: 'Peso (ex: 12kg):'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dataNascimentoController,
                  readOnly: true,
                  onTap: _pickDataNascimento,
                  decoration: const InputDecoration(
                    hintText: 'Data de nascimento:',
                    suffixIcon: Icon(Icons.calendar_today, color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Vacinado', style: TextStyle(color: AppColors.textPrimary)),
                  value: _vacinado,
                  activeThumbColor: AppColors.brandDark,
                  onChanged: (value) => setState(() => _vacinado = value),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitting ? null : _handleSalvar,
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textOnBrand,
                          ),
                        )
                      : const Text('SALVAR'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
