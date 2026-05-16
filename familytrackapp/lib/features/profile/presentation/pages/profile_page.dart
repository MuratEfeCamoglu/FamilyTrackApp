import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';
import 'package:familytrackapp/core/constants/app_text_styles.dart';
import 'package:familytrackapp/core/services/firebase_service.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_detail_entity.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/presentation/cubit/person_detail_cubit.dart';
import 'package:familytrackapp/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:familytrackapp/features/profile/presentation/pages/add_person_page.dart';
import 'package:familytrackapp/shared/widgets/loading_skeleton.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.I<ProfileCubit>()
            ..loadPersons(userId: FirebaseService.currentUserId ?? ''),
        ),
        BlocProvider(create: (_) => GetIt.I<PersonDetailCubit>()),
      ],
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  Person? _selectedPerson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              if (state.persons.isNotEmpty) {
                if (_selectedPerson == null ||
                    !state.persons.any((p) => p.id == _selectedPerson!.id)) {
                  _selectPerson(state.persons.first);
                }
              } else {
                setState(() => _selectedPerson = null);
              }
            }
            // Hata durumunu kullanıcıya göster
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red.shade400,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const PageLoadingSkeleton(showHeroCard: true, itemCount: 4);
            }
            if (state is ProfileError && _selectedPerson == null) {
              return _ErrorView(message: state.message);
            }
            if (state is ProfileLoaded && state.persons.isEmpty) {
              return _EmptyView(
                onAddPerson: () => _navigateToAddPerson(context),
              );
            }
            final persons = state is ProfileLoaded ? state.persons : <Person>[];
            if (persons.isEmpty) return const SizedBox.shrink();
            return _buildContent(context, persons);
          },
        ),
      ),
      floatingActionButton: _selectedPerson != null
          ? FloatingActionButton(
              heroTag: 'add_detail_fab',
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              onPressed: () => _showAddDetailSheet(context),
              child: const Icon(Icons.add_rounded, size: 30),
            )
              .animate()
              .scale(delay: 300.ms, duration: 500.ms, curve: Curves.elasticOut)
          : null,
    );
  }

  void _selectPerson(Person person) {
    setState(() => _selectedPerson = person);
    context.read<PersonDetailCubit>().loadDetails(
          userId: FirebaseService.currentUserId ?? '',
          person: person,
        );
  }

  void _navigateToAddPerson(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const AddPersonPage(),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Person> persons) {
    if (_selectedPerson == null) return const SizedBox.shrink();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await context.read<ProfileCubit>().loadPersons(
              userId: FirebaseService.currentUserId ?? '',
            );
      },
      child: CustomScrollView(
        slivers: [
          // ── Header: Avatar + Ad + İlişki + Ayarlar ────────
          SliverToBoxAdapter(
            child: _ProfileHeader(person: _selectedPerson!)
                .animate()
                .fade(duration: 400.ms)
                .slideY(begin: -0.1, end: 0, curve: Curves.easeOutQuad),
          ),

          // ── Kişi Seçici ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _PersonSelector(
                persons: persons,
                selectedPersonId: _selectedPerson!.id,
                onSelect: _selectPerson,
              ).animate().fade(delay: 100.ms, duration: 400.ms),
            ),
          ),

          // ── Düzenle / Yeni Kişi Ekle butonları ───────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              child: _ActionButtonsRow(
                onEdit: () {},
                onAddPerson: () => _navigateToAddPerson(context),
              ).animate().fade(delay: 200.ms, duration: 400.ms),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

          // ── Bento Grid Kartlar ───────────────────────────
          BlocBuilder<PersonDetailCubit, PersonDetailState>(
            builder: (context, detailState) {
              if (detailState is PersonDetailLoading ||
                  detailState is PersonDetailInitial) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary)),
                  ),
                );
              }

              List<PersonDetail> details = [];
              if (detailState is PersonDetailLoaded) {
                details = detailState.details;
              }
              if (detailState is PersonDetailActionSuccess) {
                details = detailState.details;
              }

              if (details.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Center(
                      child: Text(
                        'Bu kişi için henüz bilgi eklenmemiş.\n(+) Butonu ile bilgi ekleyebilirsiniz.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.95,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final detail = details[index];
                      return GestureDetector(
                        onLongPress: () =>
                            _confirmDeleteDetail(context, detail),
                        child: _BentoCard(detail: detail),
                      )
                          .animate(delay: (50 * index).ms)
                          .fade(duration: 400.ms)
                          .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuad);
                    },
                    childCount: details.length,
                  ),
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  void _showAddDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PersonDetailCubit>(),
        child: const _AddDetailSheet(),
      ),
    );
  }

  void _confirmDeleteDetail(BuildContext context, PersonDetail detail) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bilgiyi Sil'),
        content: Text('"${detail.key}" bilgisini silmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PersonDetailCubit>().deleteDetail(
                    userId: FirebaseService.currentUserId ?? '',
                    detailId: detail.id,
                  );
            },
            child: Text('Sil', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Profil Başlığı
// ─────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    final initials = person.name.isNotEmpty
        ? person.name.trim().split(' ').map((w) => w[0]).take(2).join()
        : '?';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials.toUpperCase(),
                style: AppTextStyles.h2.copyWith(color: AppColors.primaryDark),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Ad + İlişki
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person.name,
                    style: AppTextStyles.h1.copyWith(
                        fontSize: 22, color: AppColors.primaryDark)),
                Text(
                  person.relationshipType.label.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined,
                color: AppColors.textSecondary, size: 26),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Kişi Seçici
// ─────────────────────────────────────────────────────────

class _PersonSelector extends StatelessWidget {
  const _PersonSelector({
    required this.persons,
    required this.selectedPersonId,
    required this.onSelect,
  });

  final List<Person> persons;
  final String selectedPersonId;
  final ValueChanged<Person> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: persons.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final person = persons[index];
          final isActive = person.id == selectedPersonId;
          return GestureDetector(
            onTap: () => onSelect(person),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Text(
                person.name,
                style: AppTextStyles.bodyBold.copyWith(
                  color: isActive ? Colors.white : AppColors.primaryDark,
                  fontSize: 15,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Buton Satırı
// ─────────────────────────────────────────────────────────

class _ActionButtonsRow extends StatelessWidget {
  const _ActionButtonsRow({required this.onEdit, required this.onAddPerson});
  final VoidCallback onEdit;
  final VoidCallback onAddPerson;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: onEdit,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            side: const BorderSide(color: AppColors.primaryDark, width: 1.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text('Düzenle',
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: AppSpacing.sm),
        ElevatedButton.icon(
          onPressed: onAddPerson,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
          label: const Text('Yeni Kişi Ekle',
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Bento Kart — fotoğraftaki gibi tasarım
// ─────────────────────────────────────────────────────────

class _BentoCard extends StatelessWidget {
  const _BentoCard({required this.detail});
  final PersonDetail detail;

  @override
  Widget build(BuildContext context) {
    final isAlert = detail.key.toLowerCase().contains('önemli') ||
        detail.key.toLowerCase().contains('alerji');

    final iconBgColor =
        isAlert ? const Color(0xFFFFDAD6) : AppColors.primaryLight;
    final keyColor =
        isAlert ? const Color(0xFFBA1A1A) : AppColors.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border:
            isAlert ? Border.all(color: const Color(0xFFFFDAD6), width: 1.5) : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0AE91E8C),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // İkon dairesi
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                detail.icon ?? '💬',
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Başlık (küçük caps)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              detail.key.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: keyColor,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          // Değer (büyük ve bold)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              detail.value,
              style: AppTextStyles.bodyBold.copyWith(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Bilgi Ekleme Bottom Sheet
// ─────────────────────────────────────────────────────────

class _AddDetailSheet extends StatefulWidget {
  const _AddDetailSheet();

  @override
  State<_AddDetailSheet> createState() => _AddDetailSheetState();
}

class _AddDetailSheetState extends State<_AddDetailSheet> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  String _selectedIcon = '💬';
  bool _isSaving = false;

  // Önceden tanımlı kategoriler (fotoğraftaki gibi)
  static const _presetCategories = [
    {'icon': '🌸', 'label': 'En Sevdiği Çiçek'},
    {'icon': '☕', 'label': 'Kahve Tercihi'},
    {'icon': '💍', 'label': 'Yüzük Ölçüsü'},
    {'icon': '🎵', 'label': 'Favori Müzik'},
    {'icon': '🍕', 'label': 'Favori Yemek'},
    {'icon': '🌙', 'label': 'Uyku Saati'},
    {'icon': '❤️', 'label': 'Sevdiği Şey'},
    {'icon': '🏆', 'label': 'Başarısı'},
    {'icon': '✈️', 'label': 'Gitmek İstediği Yer'},
    {'icon': '📚', 'label': 'Favori Kitap'},
    {'icon': '🎨', 'label': 'Hobisi'},
    {'icon': '💊', 'label': 'İlaç / Alerji'},
    {'icon': '🌹', 'label': 'Favori Çiçek'},
    {'icon': '⭐', 'label': 'Önemli Not'},
    {'icon': '🐾', 'label': 'Evcil Hayvan'},
    {'icon': '🎮', 'label': 'Oyun Tercihi'},
    {'icon': '💬', 'label': 'Diğer'},
  ];

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.lg + bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Yeni Bilgi Ekle', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Hazır kategorilerden seçin ya da kendiniz yazın',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Hazır kategori butonları
            Text('Hızlı Kategori', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: _presetCategories.map((cat) {
                final isSelected = _selectedIcon == cat['icon'] &&
                    _keyController.text == cat['label'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = cat['icon']!;
                      _keyController.text = cat['label']!;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.primaryLight,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      '${cat['icon']} ${cat['label']}',
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Manuel giriş
            Text('Bilgi Başlığı', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                  hintText: 'Örn: Favori Çiçek, Kan Grubu'),
            ),
            const SizedBox(height: AppSpacing.md),

            Text('Değer', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _valueController,
              decoration:
                  const InputDecoration(hintText: 'Örn: Papatya, A Rh+'),
            ),
            const SizedBox(height: AppSpacing.xl),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Ekle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final key = _keyController.text.trim();
    final value = _valueController.text.trim();
    if (key.isEmpty || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen tüm alanları doldurun.')));
      return;
    }
    setState(() => _isSaving = true);
    final detail = PersonDetail(
      id: '',
      personId: '',
      key: key,
      value: value,
      icon: _selectedIcon,
      createdAt: DateTime.now(),
    );
    await context.read<PersonDetailCubit>().addDetail(
          userId: FirebaseService.currentUserId ?? '',
          detail: detail,
        );
    if (mounted) Navigator.pop(context);
  }
}

// ─────────────────────────────────────────────────────────
// Boş Durum
// ─────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onAddPerson});
  final VoidCallback onAddPerson;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people_outline_rounded,
                  size: 52, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Henüz kimse yok', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Sevdiklerinizi ekleyerek anılarınızı kaydetmeye başlayın.',
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: onAddPerson,
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('İlk Kişiyi Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Hata Görünümü
// ─────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 52, color: AppColors.primary),
            const SizedBox(height: AppSpacing.md),
            Text('Hata', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.sm),
            Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
