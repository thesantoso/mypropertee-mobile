import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/dashboard_stats_model.dart';
import '../../../../data/models/invoice_model.dart';
import '../../../../data/repositories/dashboard_repository.dart';
import '../../../../data/repositories/invoice_repository.dart';
import '../../../auth/presentation/providers/repository_providers.dart';

// Dashboard Stats Provider
class DashboardStatsNotifier extends AsyncNotifier<DashboardStatsModel> {
  @override
  Future<DashboardStatsModel> build() async {
    return _fetchStats();
  }

  Future<DashboardStatsModel> _fetchStats() async {
    final repository = ref.read(dashboardRepositoryProvider);
    return repository.getDashboardStats();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchStats);
  }
}

final dashboardStatsProvider =
    AsyncNotifierProvider<DashboardStatsNotifier, DashboardStatsModel>(
  DashboardStatsNotifier.new,
);

// Recent Invoices Provider (for dashboard)
class RecentInvoicesNotifier extends AsyncNotifier<List<InvoiceModel>> {
  @override
  Future<List<InvoiceModel>> build() async {
    return _fetchInvoices();
  }

  Future<List<InvoiceModel>> _fetchInvoices() async {
    final repository = ref.read(invoiceRepositoryProvider);
    final result = await repository.getInvoices(page: 1, pageSize: 5);
    return result.items;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchInvoices);
  }
}

final recentInvoicesProvider =
    AsyncNotifierProvider<RecentInvoicesNotifier, List<InvoiceModel>>(
  RecentInvoicesNotifier.new,
);
