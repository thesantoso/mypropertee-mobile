import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/invoices_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/badges/status_badge.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/loaders/app_loader.dart';

class InvoiceDetailScreen extends ConsumerWidget {
  final String invoiceId;

  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceDetailProvider(invoiceId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Detail')),
      body: invoiceAsync.when(
        loading: () => const AppLoader(),
        error: (error, _) => AppErrorWidget(message: error.toString()),
        data: (invoice) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          invoice.invoiceNumber,
                          style: theme.textTheme.headlineSmall,
                        ),
                        StatusBadge.fromInvoiceStatus(invoice.status),
                      ],
                    ),
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Tenant',
                      value: invoice.tenantName,
                    ),
                    _DetailRow(
                      label: 'Due Date',
                      value: DateFormatter.formatDate(invoice.dueDate),
                    ),
                    if (invoice.paidAt != null)
                      _DetailRow(
                        label: 'Paid At',
                        value: DateFormatter.formatDateTime(invoice.paidAt!),
                      ),
                    if (invoice.description != null)
                      _DetailRow(
                        label: 'Description',
                        value: invoice.description!,
                      ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', style: theme.textTheme.titleMedium),
                        Text(
                          CurrencyFormatter.formatIDR(invoice.amount),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (invoice.status == InvoiceStatus.unpaid ||
                  invoice.status == InvoiceStatus.overdue) ...[
                const SizedBox(height: AppDimensions.spaceXLarge),
                AppButton(
                  label: 'Pay Now',
                  onPressed: () {},
                  leadingIcon: Icons.payment_rounded,
                ),
              ],
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
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
