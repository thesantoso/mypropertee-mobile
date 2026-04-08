import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/buttons/app_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Logo
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.apartment_rounded,
                  size: 36,
                  color: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXLarge),
              // Title
              Text(
                AppStrings.welcome,
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: AppDimensions.spaceSmall),
              Text(
                AppStrings.welcomeSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 60),
              // Error message
              if (authState.hasError) ...[
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingDefault),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusLarge),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: AppDimensions.spaceSmall),
                      Expanded(
                        child: Text(
                          authState.errorMessage ?? AppStrings.errorOccurred,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceDefault),
              ],
              // Login Button
              AppButton(
                label: AppStrings.signInWithSSO,
                onPressed: () => authNotifier.login(),
                isLoading: authState.isLoading,
                leadingIcon: Icons.lock_outline_rounded,
              ),
              const SizedBox(height: AppDimensions.spaceDefault),
              // Info text
              Center(
                child: Text(
                  'Powered by Authentik OIDC',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXXLarge),
              // Features
              _buildFeatureItem(
                context,
                icon: Icons.apartment_outlined,
                title: 'Property Management',
                subtitle: 'Manage all your properties in one place',
              ),
              const SizedBox(height: AppDimensions.spaceDefault),
              _buildFeatureItem(
                context,
                icon: Icons.receipt_long_outlined,
                title: 'Invoice & Payments',
                subtitle: 'Track invoices and process payments seamlessly',
              ),
              const SizedBox(height: AppDimensions.spaceDefault),
              _buildFeatureItem(
                context,
                icon: Icons.report_outlined,
                title: 'Incident Reporting',
                subtitle: 'Report and track maintenance issues',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(15),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: AppDimensions.spaceDefault),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
