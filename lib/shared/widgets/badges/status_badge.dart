import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/invoice_model.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/unit_model.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  factory StatusBadge.fromInvoiceStatus(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return StatusBadge(
          label: 'Paid',
          color: AppColors.success,
          backgroundColor: AppColors.successLight,
        );
      case InvoiceStatus.unpaid:
        return StatusBadge(
          label: 'Unpaid',
          color: AppColors.warning,
          backgroundColor: AppColors.warningLight,
        );
      case InvoiceStatus.overdue:
        return StatusBadge(
          label: 'Overdue',
          color: AppColors.error,
          backgroundColor: AppColors.errorLight,
        );
      case InvoiceStatus.cancelled:
        return StatusBadge(
          label: 'Cancelled',
          color: AppColors.textSecondary,
          backgroundColor: AppColors.surfaceVariant,
        );
    }
  }

  factory StatusBadge.fromIncidentStatus(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.open:
        return StatusBadge(
          label: 'Open',
          color: AppColors.error,
          backgroundColor: AppColors.errorLight,
        );
      case IncidentStatus.inProgress:
        return StatusBadge(
          label: 'In Progress',
          color: AppColors.warning,
          backgroundColor: AppColors.warningLight,
        );
      case IncidentStatus.resolved:
        return StatusBadge(
          label: 'Resolved',
          color: AppColors.success,
          backgroundColor: AppColors.successLight,
        );
      case IncidentStatus.closed:
        return StatusBadge(
          label: 'Closed',
          color: AppColors.textSecondary,
          backgroundColor: AppColors.surfaceVariant,
        );
    }
  }

  factory StatusBadge.fromUnitStatus(UnitStatus status) {
    switch (status) {
      case UnitStatus.occupied:
        return StatusBadge(
          label: 'Occupied',
          color: AppColors.success,
          backgroundColor: AppColors.successLight,
        );
      case UnitStatus.vacant:
        return StatusBadge(
          label: 'Vacant',
          color: AppColors.primary,
          backgroundColor: AppColors.primary.withAlpha(20),
        );
      case UnitStatus.maintenance:
        return StatusBadge(
          label: 'Maintenance',
          color: AppColors.warning,
          backgroundColor: AppColors.warningLight,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSmall,
        vertical: AppDimensions.paddingXSmall,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
