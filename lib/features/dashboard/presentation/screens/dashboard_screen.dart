import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';
import '../providers/dashboard_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../data/models/dashboard_stats_model.dart';
import '../../../../data/models/invoice_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/badges/status_badge.dart';
import '../../../../shared/widgets/loaders/app_loader.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final recentInvoicesAsync = ref.watch(recentInvoicesProvider);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appName,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            Text(
              AppStrings.appTagline,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(dashboardStatsProvider.notifier).refresh();
          await ref.read(recentInvoicesProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Section
              _buildStatsSection(context, statsAsync),
              const SizedBox(height: AppDimensions.spaceXLarge),
              // Quick Actions
              _buildQuickActions(context),
              const SizedBox(height: AppDimensions.spaceXLarge),
              // Recent Invoices
              _buildRecentInvoicesSection(context, ref, recentInvoicesAsync),
              const SizedBox(height: AppDimensions.spaceXLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    AsyncValue<DashboardStatsModel> statsAsync,
  ) {
    final isLoading = statsAsync.isLoading;
    final stats = statsAsync.valueOrNull ?? DashboardStatsModel.placeholder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppDimensions.spaceDefault),
        Skeletonizer(
          enabled: isLoading,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppDimensions.spaceSmall,
            mainAxisSpacing: AppDimensions.spaceSmall,
            childAspectRatio: 1.3,
            children: [
              StatCard(
                title: AppStrings.totalProperties,
                value: stats.totalProperties.toString(),
                icon: Icons.apartment_rounded,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primary.withAlpha(20),
              ),
              StatCard(
                title: AppStrings.totalUnits,
                value: stats.totalUnits.toString(),
                icon: Icons.door_front_door_outlined,
                iconColor: AppColors.secondary,
                iconBgColor: AppColors.secondary.withAlpha(20),
              ),
              StatCard(
                title: AppStrings.activeInvoices,
                value: stats.activeInvoices.toString(),
                icon: Icons.receipt_long_rounded,
                iconColor: AppColors.warning,
                iconBgColor: AppColors.warning.withAlpha(20),
              ),
              StatCard(
                title: AppStrings.pendingIncidents,
                value: stats.pendingIncidents.toString(),
                icon: Icons.report_rounded,
                iconColor: AppColors.error,
                iconBgColor: AppColors.error.withAlpha(20),
              ),
            ],
          ),
        ),
        // Occupancy Rate
        if (!isLoading) ...[
          const SizedBox(height: AppDimensions.spaceSmall),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Occupancy Rate',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${stats.occupancyRate.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: stats.occupancyRate / 100,
                  backgroundColor: AppColors.surfaceVariant,
                  color: AppColors.primary,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text(
                  '${stats.occupiedUnits} of ${stats.totalUnits} units occupied',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.quickActions,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppDimensions.spaceDefault),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.apartment_rounded,
                label: AppStrings.properties,
                color: AppColors.primary,
                onTap: () => context.go(AppRoutes.properties),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSmall),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.receipt_long_rounded,
                label: AppStrings.invoices,
                color: AppColors.warning,
                onTap: () => context.go(AppRoutes.invoices),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSmall),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.report_rounded,
                label: AppStrings.incidents,
                color: AppColors.error,
                onTap: () => context.go(AppRoutes.incidents),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSmall),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.payments_rounded,
                label: AppStrings.payments,
                color: AppColors.secondary,
                onTap: () => context.go(AppRoutes.payments),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentInvoicesSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<InvoiceModel>> recentInvoicesAsync,
  ) {
    final isLoading = recentInvoicesAsync.isLoading;
    final invoices = recentInvoicesAsync.valueOrNull ??
        List.generate(
          3,
          (i) => InvoiceModel(
            id: '$i',
            invoiceNumber: 'INV-00$i',
            propertyId: '',
            unitId: '',
            tenantId: '',
            tenantName: 'Loading Tenant',
            amount: 1000000,
            status: InvoiceStatus.unpaid,
            dueDate: DateTime.now(),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Invoices',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.invoices),
              child: const Text(AppStrings.viewAll),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceSmall),
        if (recentInvoicesAsync.hasError)
          AppErrorWidget(
            message: recentInvoicesAsync.error.toString(),
            onRetry: () =>
                ref.read(recentInvoicesProvider.notifier).refresh(),
          )
        else
          Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: invoices.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppDimensions.spaceSmall),
              itemBuilder: (context, index) =>
                  _InvoiceListItem(invoice: invoices[index]),
            ),
          ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingDefault,
          horizontal: AppDimensions.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceListItem extends StatelessWidget {
  final InvoiceModel invoice;

  const _InvoiceListItem({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  invoice.tenantName,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.formatCompact(invoice.amount),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              StatusBadge.fromInvoiceStatus(invoice.status),
            ],
          ),
        ],
      ),
    );
  }
}
