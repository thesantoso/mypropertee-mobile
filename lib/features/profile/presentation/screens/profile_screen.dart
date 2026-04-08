import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/profile_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/dialogs/confirm_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withAlpha(20),
                    child: profileAsync.maybeWhen(
                      data: (user) => user?.avatarUrl != null
                          ? null
                          : Text(
                              _getInitials(user?.name ?? 'U'),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                      orElse: () => const Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  profileAsync.maybeWhen(
                    data: (user) => Column(
                      children: [
                        Text(
                          user?.name ?? 'User',
                          style: theme.textTheme.headlineSmall,
                        ),
                        Text(
                          user?.email ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (user?.role != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user!.role!,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Settings Sections
            _buildSection(
              context,
              title: 'Account',
              items: [
                _SettingsItem(
                  icon: Icons.person_outline_rounded,
                  label: AppStrings.editProfile,
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.notifications_outlined,
                  label: AppStrings.notifications,
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.lock_outline_rounded,
                  label: AppStrings.privacy,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildSection(
              context,
              title: 'Support',
              items: [
                _SettingsItem(
                  icon: Icons.help_outline_rounded,
                  label: AppStrings.helpSupport,
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.info_outline_rounded,
                  label: AppStrings.about,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildSection(
              context,
              title: '',
              items: [
                _SettingsItem(
                  icon: Icons.logout_rounded,
                  label: AppStrings.logout,
                  labelColor: AppColors.error,
                  iconColor: AppColors.error,
                  onTap: () async {
                    final confirmed = await ConfirmDialog.show(
                      context,
                      title: AppStrings.logout,
                      message: 'Are you sure you want to logout?',
                      confirmText: AppStrings.logout,
                      isDangerous: true,
                    );
                    if (confirmed == true) {
                      await authNotifier.logout();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceXXLarge),
            Text(
              '${AppStrings.appName} v1.0.0',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppDimensions.spaceLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_SettingsItem> items,
  }) {
    return Container(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
              ),
            ),
          ...items.map((item) => _buildItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, _SettingsItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingDefault,
          vertical: AppDimensions.paddingMedium,
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: item.iconColor ?? AppColors.textSecondary,
              size: AppDimensions.iconDefault,
            ),
            const SizedBox(width: AppDimensions.spaceDefault),
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: item.labelColor,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textDisabled,
              size: AppDimensions.iconDefault,
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.iconColor,
    this.labelColor,
    this.onTap,
  });
}
