import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/models.dart';
import '../../../../data/repositories/payment_repository.dart';
import '../../../auth/presentation/providers/repository_providers.dart';

class PaymentsNotifier extends AsyncNotifier<List<PaymentModel>> {
  @override
  Future<List<PaymentModel>> build() async {
    return _fetchPayments();
  }

  Future<List<PaymentModel>> _fetchPayments() async {
    final repository = ref.read(paymentRepositoryProvider);
    final result = await repository.getPayments();
    return result.items;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchPayments);
  }

  Future<PaymentModel> createPayment(Map<String, dynamic> data) async {
    final repository = ref.read(paymentRepositoryProvider);
    final payment = await repository.createPayment(data);
    state = AsyncData([payment, ...state.valueOrNull ?? []]);
    return payment;
  }
}

final paymentsProvider =
    AsyncNotifierProvider<PaymentsNotifier, List<PaymentModel>>(
  PaymentsNotifier.new,
);
