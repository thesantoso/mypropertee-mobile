import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/models.dart';
import '../../../../data/repositories/incident_repository.dart';
import '../../../auth/presentation/providers/repository_providers.dart';

class IncidentsNotifier extends AsyncNotifier<List<IncidentModel>> {
  int _page = 1;
  bool _hasMore = true;

  @override
  Future<List<IncidentModel>> build() async {
    _page = 1;
    _hasMore = true;
    return _fetchIncidents();
  }

  Future<List<IncidentModel>> _fetchIncidents() async {
    final repository = ref.read(incidentRepositoryProvider);
    final result = await repository.getIncidents(page: _page);
    _hasMore = result.hasNextPage;
    return result.items;
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchIncidents);
  }
}

final incidentsProvider =
    AsyncNotifierProvider<IncidentsNotifier, List<IncidentModel>>(
  IncidentsNotifier.new,
);

final incidentDetailProvider =
    FutureProvider.family<IncidentModel, String>((ref, id) async {
  final repository = ref.read(incidentRepositoryProvider);
  return repository.getIncidentById(id);
});
