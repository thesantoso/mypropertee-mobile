import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/payments_provider.dart';
import '../../../../data/models/payment_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/loaders/app_loader.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.payments)),
      body: paymentsAsync.when(
        loading: () => Skeletonizer(
          enabled: true,
          child: _buildList(
            List.generate(
              5,
              (_) => PaymentModel(
                id: '1',
                invoiceId: '1',
                invoiceNumber: 'INV-001',
                amount: 2000000,
                status: PaymentStatus.success,
                createdAt: DateTime.now(),
              ),
            ),
            context,
          ),
        ),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.read(paymentsProvider.notifier).refresh(),
        ),
        data: (payments) {
          if (payments.isEmpty) {
            return const AppEmptyWidget(
              icon: Icons.payments_outlined,
              message: 'No payment history yet.',
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(paymentsProvider.notifier).refresh(),
            child: _buildList(payments, context),
          );
        },
      ),
    );
  }

  Widget _buildList(List<PaymentModel> payments, BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingDefault),
      itemCount: payments.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppDimensions.spaceSmall),
      itemBuilder: (context, index) => _PaymentCard(payment: payments[index]),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final PaymentModel payment;

  const _PaymentCard({required this.payment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(payment.status);

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withAlpha(20),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Icon(
              _getMethodIcon(payment.method),
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.invoiceNumber, style: theme.textTheme.titleMedium),
                Text(
                  DateFormatter.formatDate(payment.createdAt),
                  style: theme.textTheme.bodySmall,
                ),
                if (payment.method != null)
                  Text(
                    payment.method!.name.toUpperCase(),
                    style: theme.textTheme.labelSmall,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.formatCompact(payment.amount),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  payment.status.name,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:
        return AppColors.success;
      case PaymentStatus.pending:
        return AppColors.warning;
      case PaymentStatus.failed:
      case PaymentStatus.expired:
      case PaymentStatus.cancelled:
        return AppColors.error;
    }
  }

  IconData _getMethodIcon(PaymentMethod? method) {
    switch (method) {
      case PaymentMethod.virtualAccount:
        return Icons.account_balance_rounded;
      case PaymentMethod.creditCard:
        return Icons.credit_card_rounded;
      case PaymentMethod.ewallet:
        return Icons.wallet_rounded;
      case PaymentMethod.qris:
        return Icons.qr_code_rounded;
      default:
        return Icons.payments_rounded;
    }
  }
}
