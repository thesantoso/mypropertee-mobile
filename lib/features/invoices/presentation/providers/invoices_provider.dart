import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/models.dart';
import '../../../../data/repositories/invoice_repository.dart';
import '../../../auth/presentation/providers/repository_providers.dart';

class InvoicesNotifier extends AsyncNotifier<List<InvoiceModel>> {
  int _page = 1;
  bool _hasMore = true;
  String? _statusFilter;

  @override
  Future<List<InvoiceModel>> build() async {
    _page = 1;
    _hasMore = true;
    return _fetchInvoices();
  }

  Future<List<InvoiceModel>> _fetchInvoices() async {
    final repository = ref.read(invoiceRepositoryProvider);
    final result = await repository.getInvoices(
      page: _page,
      status: _statusFilter,
    );
    _hasMore = result.hasNextPage;
    return result.items;
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchInvoices);
  }

  void setStatusFilter(String? status) {
    _statusFilter = status;
    refresh();
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    _page++;
    final currentList = state.valueOrNull ?? [];
    try {
      final more = await _fetchInvoices();
      state = AsyncData([...currentList, ...more]);
    } catch (e) {
      _page--;
    }
  }
}

final invoicesProvider =
    AsyncNotifierProvider<InvoicesNotifier, List<InvoiceModel>>(
  InvoicesNotifier.new,
);

final invoiceDetailProvider =
    FutureProvider.family<InvoiceModel, String>((ref, id) async {
  final repository = ref.read(invoiceRepositoryProvider);
  return repository.getInvoiceById(id);
});

final invoiceStatusFilterProvider = StateProvider<String?>((ref) => null);
