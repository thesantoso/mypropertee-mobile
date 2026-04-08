import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';
import '../providers/incidents_provider.dart';
import '../../../../data/models/incident_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/badges/status_badge.dart';
import '../../../../shared/widgets/loaders/app_loader.dart';

class IncidentsScreen extends ConsumerWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidentsAsync = ref.watch(incidentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.incidents)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
      body: incidentsAsync.when(
        loading: () => Skeletonizer(
          enabled: true,
          child: _buildList(
            List.generate(
              5,
              (i) => IncidentModel(
                id: '$i',
                propertyId: '',
                unitId: '',
                title: 'Loading Incident Title',
                description: 'Loading description text here',
                status: IncidentStatus.open,
                priority: IncidentPriority.medium,
                createdAt: DateTime.now(),
              ),
            ),
            context,
          ),
        ),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.read(incidentsProvider.notifier).refresh(),
        ),
        data: (incidents) {
          if (incidents.isEmpty) {
            return AppEmptyWidget(
              icon: Icons.report_outlined,
              message: 'No incidents reported.',
              action: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text(AppStrings.reportIncident),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(incidentsProvider.notifier).refresh(),
            child: _buildList(incidents, context),
          );
        },
      ),
    );
  }

  Widget _buildList(List<IncidentModel> incidents, BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingDefault),
      itemCount: incidents.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppDimensions.spaceSmall),
      itemBuilder: (context, index) =>
          IncidentCard(incident: incidents[index]),
    );
  }
}

class IncidentCard extends StatelessWidget {
  final IncidentModel incident;

  const IncidentCard({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: () => context.go(AppRoutes.incidentDetail(incident.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _priorityColor(incident.priority).withAlpha(20),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Icon(
                  Icons.report_outlined,
                  color: _priorityColor(incident.priority),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceDefault),
              Expanded(
                child: Text(
                  incident.title,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StatusBadge.fromIncidentStatus(incident.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            incident.description,
            style: theme.textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _PriorityBadge(priority: incident.priority),
              const Spacer(),
              Text(
                DateFormatter.formatRelative(incident.createdAt),
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _priorityColor(IncidentPriority priority) {
    switch (priority) {
      case IncidentPriority.low:
        return AppColors.secondary;
      case IncidentPriority.medium:
        return AppColors.warning;
      case IncidentPriority.high:
        return Colors.orange;
      case IncidentPriority.critical:
        return AppColors.error;
    }
  }
}

class _PriorityBadge extends StatelessWidget {
  final IncidentPriority priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        priority.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _color() {
    switch (priority) {
      case IncidentPriority.low:
        return AppColors.secondary;
      case IncidentPriority.medium:
        return AppColors.warning;
      case IncidentPriority.high:
        return Colors.orange;
      case IncidentPriority.critical:
        return AppColors.error;
    }
  }
}
