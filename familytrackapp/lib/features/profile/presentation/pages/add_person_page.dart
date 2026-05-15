import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_decorations.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';
import 'package:familytrackapp/core/constants/app_strings.dart';
import 'package:familytrackapp/core/constants/app_text_styles.dart';
import 'package:familytrackapp/core/services/firebase_service.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/presentation/cubit/profile_cubit.dart';

/// Yeni kişi ekleme sayfası.
class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  RelationshipType _selectedType = RelationshipType.other;
  DateTime _startDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Yeni Kişi Ekle'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // ── Profil fotoğrafı placeholder ──────────────
            Center(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fotoğraf seçimi yakında eklenecek!'),
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_a_photo_rounded,
                    color: AppColors.primary,
                    size: 36,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: Text(
                'Fotoğraf Ekle',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Ad ────────────────────────────────────────
            Text('Ad Soyad', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Örn: Annem, Ahmet, Canım',
                prefixIcon: Icon(Icons.person_rounded),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Lutfen bir isim girin.';
                }
                if (v.trim().length < 2) {
                  return 'Isim en az 2 karakter olmalidir.';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── İlişki Türü ───────────────────────────────
            Text('İlişki Türü', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            _RelationshipSelector(
              selected: _selectedType,
              onChanged: (t) => setState(() => _selectedType = t),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Başlangıç Tarihi ──────────────────────────
            Text('Birliktelik Başlangıç Tarihi', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tanıştığınız veya birlikte olmaya başladığınız tarih',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _DatePickerField(
              date: _startDate,
              onChanged: (d) => setState(() => _startDate = d),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Kaydet ────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = FirebaseService.currentUserId;
    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.errorAuthRequired)),
      );
      return;
    }

    setState(() => _isSaving = true);
    final now = DateTime.now();
    final person = Person(
      id: '',
      name: _nameController.text.trim(),
      relationshipType: _selectedType,
      startDate: _startDate,
      createdAt: now,
    );
    bool success = false;
    try {
      success = await context
          .read<ProfileCubit>()
          .addPerson(userId: userId, person: person)
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.errorNetwork)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.errorGeneric)));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }

    if (!mounted) return;
    if (!success) {
      final state = context.read<ProfileCubit>().state;
      final message = state is ProfileError
          ? state.message
          : AppStrings.errorGeneric;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    Navigator.pop(context);
  }
}

// ─────────────────────────────────────────────────────────

class _RelationshipSelector extends StatelessWidget {
  const _RelationshipSelector({
    required this.selected,
    required this.onChanged,
  });
  final RelationshipType selected;
  final ValueChanged<RelationshipType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: RelationshipType.values.map((type) {
        final isSelected = type == selected;
        return GestureDetector(
          onTap: () => onChanged(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.sm + 4),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.primaryLight,
                width: 1.5,
              ),
              boxShadow: isSelected ? AppDecorations.cardShadow : null,
            ),
            child: Text(
              '${type.emoji} ${type.label}',
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({required this.date, required this.onChanged});
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final d = date;
    final formatted =
        '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: d,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          locale: const Locale('tr', 'TR'),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(color: AppColors.primaryLight, width: 1.5),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(formatted, style: AppTextStyles.body),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
