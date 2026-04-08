import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/incidents_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/badges/status_badge.dart';
import '../../../../shared/widgets/loaders/app_loader.dart';

class IncidentDetailScreen extends ConsumerWidget {
  final String incidentId;

  const IncidentDetailScreen({super.key, required this.incidentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidentAsync = ref.watch(incidentDetailProvider(incidentId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Detail'),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
        ],
      ),
      body: incidentAsync.when(
        loading: () => const AppLoader(),
        error: (error, _) => AppErrorWidget(message: error.toString()),
        data: (incident) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            incident.title,
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge.fromIncidentStatus(incident.status),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceDefault),
                    Text(
                      incident.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Priority',
                      value: incident.priority.name.toUpperCase(),
                    ),
                    _DetailRow(
                      label: 'Reported',
                      value: DateFormatter.formatDate(incident.createdAt),
                    ),
                    if (incident.reportedBy != null)
                      _DetailRow(
                        label: 'Reported By',
                        value: incident.reportedBy!,
                      ),
                    if (incident.assignedTo != null)
                      _DetailRow(
                        label: 'Assigned To',
                        value: incident.assignedTo!,
                      ),
                    if (incident.resolvedAt != null)
                      _DetailRow(
                        label: 'Resolved At',
                        value:
                            DateFormatter.formatDateTime(incident.resolvedAt!),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
