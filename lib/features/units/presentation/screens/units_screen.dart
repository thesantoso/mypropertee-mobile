import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';
import '../providers/units_provider.dart';
import '../../../../data/models/unit_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/badges/status_badge.dart';
import '../../../../shared/widgets/loaders/app_loader.dart';

class UnitsScreen extends ConsumerWidget {
  final String propertyId;

  const UnitsScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitsAsync = ref.watch(unitsProvider(propertyId));

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.units)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
      body: unitsAsync.when(
        loading: () => Skeletonizer(
          enabled: true,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.paddingDefault),
            itemCount: 5,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppDimensions.spaceSmall),
            itemBuilder: (_, i) => UnitCard(
              unit: UnitModel(
                id: '$i',
                propertyId: propertyId,
                unitNumber: 'A-10$i',
                type: 'Studio',
                status: UnitStatus.occupied,
                monthlyRent: 2000000,
              ),
            ),
          ),
        ),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () =>
              ref.read(unitsProvider(propertyId).notifier).refresh(),
        ),
        data: (units) {
          if (units.isEmpty) {
            return const AppEmptyWidget(
              icon: Icons.door_front_door_outlined,
              message: 'No units found.',
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(unitsProvider(propertyId).notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.paddingDefault),
              itemCount: units.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppDimensions.spaceSmall),
              itemBuilder: (context, index) => UnitCard(unit: units[index]),
            ),
          );
        },
      ),
    );
  }
}

class UnitCard extends StatelessWidget {
  final UnitModel unit;

  const UnitCard({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: () => context.go(
          AppRoutes.unitDetail(unit.propertyId, unit.id)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: const Icon(
              Icons.door_front_door_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unit ${unit.unitNumber}',
                  style: theme.textTheme.titleMedium,
                ),
                Text(unit.type, style: theme.textTheme.bodySmall),
                if (unit.tenantName != null)
                  Text(
                    unit.tenantName!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge.fromUnitStatus(unit.status),
              if (unit.monthlyRent != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Rp ${(unit.monthlyRent! / 1000000).toStringAsFixed(1)}M',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
