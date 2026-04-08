import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/units_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/badges/status_badge.dart';
import '../../../../shared/widgets/loaders/app_loader.dart';

class UnitDetailScreen extends ConsumerWidget {
  final String unitId;

  const UnitDetailScreen({super.key, required this.unitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitAsync = ref.watch(unitDetailProvider(unitId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Details'),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
        ],
      ),
      body: unitAsync.when(
        loading: () => const AppLoader(),
        error: (error, _) => AppErrorWidget(message: error.toString()),
        data: (unit) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Unit ${unit.unitNumber}',
                          style: theme.textTheme.headlineSmall,
                        ),
                        StatusBadge.fromUnitStatus(unit.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      unit.type,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    if (unit.floorArea != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${unit.floorArea} m²',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    if (unit.monthlyRent != null) ...[
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Monthly Rent',
                              style: theme.textTheme.bodyMedium),
                          Text(
                            CurrencyFormatter.formatIDR(unit.monthlyRent!),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (unit.tenantName != null) ...[
                const SizedBox(height: AppDimensions.spaceDefault),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tenant', style: theme.textTheme.titleMedium),
                      const Divider(height: 16),
                      Text(
                        unit.tenantName!,
                        style: theme.textTheme.bodyLarge,
                      ),
                      if (unit.leaseStart != null && unit.leaseEnd != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Lease: ${DateFormatter.formatDate(unit.leaseStart!)} - ${DateFormatter.formatDate(unit.leaseEnd!)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
