import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';
import '../providers/invoices_provider.dart';
import '../../../../data/models/invoice_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/badges/status_badge.dart';
import '../../../../shared/widgets/loaders/app_loader.dart';

class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesProvider);
    final statusFilter = ref.watch(invoiceStatusFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.invoices),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterBottomSheet(context, ref, statusFilter),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          if (statusFilter != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Chip(
                    label: Text(statusFilter),
                    onDeleted: () {
                      ref.read(invoiceStatusFilterProvider.notifier).state =
                          null;
                      ref
                          .read(invoicesProvider.notifier)
                          .setStatusFilter(null);
                    },
                    deleteIcon: const Icon(Icons.close, size: 16),
                  ),
                ],
              ),
            ),
          Expanded(
            child: invoicesAsync.when(
              loading: () => _buildLoadingList(),
              error: (error, _) => AppErrorWidget(
                message: error.toString(),
                onRetry: () =>
                    ref.read(invoicesProvider.notifier).refresh(),
              ),
              data: (invoices) {
                if (invoices.isEmpty) {
                  return const AppEmptyWidget(
                    icon: Icons.receipt_long_outlined,
                    message: 'No invoices found.',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(invoicesProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppDimensions.paddingDefault),
                    itemCount: invoices.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppDimensions.spaceSmall),
                    itemBuilder: (context, index) =>
                        InvoiceCard(invoice: invoices[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    final dummyInvoice = InvoiceModel(
      id: '1',
      invoiceNumber: 'INV-001',
      propertyId: '',
      unitId: '',
      tenantId: '',
      tenantName: 'Loading Tenant Name',
      amount: 2500000,
      status: InvoiceStatus.unpaid,
      dueDate: DateTime.now(),
    );

    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.paddingDefault),
        itemCount: 6,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppDimensions.spaceSmall),
        itemBuilder: (_, __) => InvoiceCard(invoice: dummyInvoice),
      ),
    );
  }

  void _showFilterBottomSheet(
      BuildContext context, WidgetRef ref, String? current) {
    final filters = ['paid', 'unpaid', 'overdue', 'cancelled'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXLarge)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingDefault),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Status',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ...filters.map(
              (f) => ListTile(
                title: Text(f.capitalize()),
                trailing:
                    current == f ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  ref.read(invoiceStatusFilterProvider.notifier).state =
                      f == current ? null : f;
                  ref.read(invoicesProvider.notifier).setStatusFilter(
                        f == current ? null : f,
                      );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceCard({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: () => context.go(AppRoutes.invoiceDetail(invoice.id)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _statusColor(invoice.status).withAlpha(20),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: _statusColor(invoice.status),
              size: 22,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(invoice.invoiceNumber, style: theme.textTheme.titleMedium),
                Text(invoice.tenantName, style: theme.textTheme.bodySmall),
                Text(
                  'Due: ${DateFormatter.formatDate(invoice.dueDate)}',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.formatCompact(invoice.amount),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
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

  Color _statusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return AppColors.success;
      case InvoiceStatus.unpaid:
        return AppColors.warning;
      case InvoiceStatus.overdue:
        return AppColors.error;
      case InvoiceStatus.cancelled:
        return AppColors.textSecondary;
    }
  }
}
