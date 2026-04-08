import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';
import '../providers/properties_provider.dart';
import '../../../../data/models/property_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/loaders/app_loader.dart';

class PropertiesScreen extends ConsumerWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(propertiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.properties),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
      body: propertiesAsync.when(
        loading: () => _buildLoadingList(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.read(propertiesProvider.notifier).refresh(),
        ),
        data: (properties) {
          if (properties.isEmpty) {
            return AppEmptyWidget(
              icon: Icons.apartment_outlined,
              message: 'No properties found.\nAdd your first property!',
              action: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text(AppStrings.addProperty),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(propertiesProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.paddingDefault),
              itemCount: properties.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppDimensions.spaceSmall),
              itemBuilder: (context, index) =>
                  PropertyCard(property: properties[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingList() {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.paddingDefault),
        itemCount: 5,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppDimensions.spaceSmall),
        itemBuilder: (context, index) => PropertyCard(
          property: PropertyModel(
            id: '$index',
            name: 'Loading Property Name',
            address: '123 Loading Street, City',
            type: 'Apartment',
            totalUnits: 20,
            occupiedUnits: 15,
          ),
        ),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final PropertyModel property;

  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: () => context.go(AppRoutes.propertyDetail(property.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(15),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: const Icon(
                  Icons.apartment_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceDefault),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.name,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      property.type,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceDefault),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  property.address,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          const Divider(),
          const SizedBox(height: AppDimensions.spaceSmall),
          Row(
            children: [
              _PropertyStat(
                label: 'Total Units',
                value: property.totalUnits.toString(),
              ),
              const SizedBox(width: AppDimensions.spaceDefault),
              _PropertyStat(
                label: 'Occupied',
                value: property.occupiedUnits.toString(),
                valueColor: AppColors.secondary,
              ),
              const SizedBox(width: AppDimensions.spaceDefault),
              _PropertyStat(
                label: 'Vacant',
                value: property.vacantUnits.toString(),
                valueColor: AppColors.warning,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${property.occupancyRate.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PropertyStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PropertyStat({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: valueColor,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}
