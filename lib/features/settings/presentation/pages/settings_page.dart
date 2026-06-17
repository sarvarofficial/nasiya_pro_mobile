import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Sozlamalar sahifasi
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sozlamalar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'NP',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Foydalanuvchi', style: AppTextStyles.labelLarge),
                      const SizedBox(height: 2),
                      Text(
                        'Sotuvchi • Asosiy filial',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // General section
          Text('Umumiy', style: AppTextStyles.labelSmall),
          const SizedBox(height: AppSpacing.sm),
          _SettingsGroup(
            items: [
              _SettingsItem(
                icon: Icons.dark_mode_outlined,
                title: 'Qorong\'u rejim',
                trailing: Switch(
                  value: false,
                  onChanged: (_) {},
                  activeColor: AppColors.primary,
                ),
              ),
              _SettingsItem(
                icon: Icons.language,
                title: 'Til',
                subtitle: 'O\'zbek',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.notifications_outlined,
                title: 'Bildirishnomalar',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Security section
          Text('Xavfsizlik', style: AppTextStyles.labelSmall),
          const SizedBox(height: AppSpacing.sm),
          _SettingsGroup(
            items: [
              _SettingsItem(
                icon: Icons.pin_outlined,
                title: 'PIN kodni o\'zgartirish',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.fingerprint,
                title: 'Biometric kirish',
                trailing: Switch(
                  value: false,
                  onChanged: (_) {},
                  activeColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // About section
          Text('Ilova haqida', style: AppTextStyles.labelSmall),
          const SizedBox(height: AppSpacing.sm),
          _SettingsGroup(
            items: [
              _SettingsItem(
                icon: Icons.info_outline,
                title: 'Versiya',
                subtitle: '1.0.0',
              ),
              _SettingsItem(
                icon: Icons.description_outlined,
                title: 'Foydalanish shartlari',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Logout
          OutlinedButton.icon(
            onPressed: () {
              // TODO: AuthBloc logout
            },
            icon: const Icon(Icons.logout, color: AppColors.error),
            label: Text(
              'Chiqish',
              style: AppTextStyles.buttonText.copyWith(color: AppColors.error),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              items[index],
              if (index < items.length - 1)
                const Divider(height: 0, indent: 56),
            ],
          );
        }),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium),
                  if (subtitle != null)
                    Text(subtitle!, style: AppTextStyles.caption),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}
