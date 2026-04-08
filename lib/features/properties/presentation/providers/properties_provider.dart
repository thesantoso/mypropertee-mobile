import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/models.dart';
import '../../../../data/repositories/property_repository.dart';
import '../../../auth/presentation/providers/repository_providers.dart';

class PropertiesNotifier extends AsyncNotifier<List<PropertyModel>> {
  int _page = 1;
  bool _hasMore = true;

  @override
  Future<List<PropertyModel>> build() async {
    _page = 1;
    _hasMore = true;
    return _fetchProperties();
  }

  Future<List<PropertyModel>> _fetchProperties({bool reset = false}) async {
    final repository = ref.read(propertyRepositoryProvider);
    final result = await repository.getProperties(page: _page);
    _hasMore = result.hasNextPage;
    return result.items;
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchProperties(reset: true));
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    _page++;
    final currentList = state.valueOrNull ?? [];
    try {
      final more = await _fetchProperties();
      state = AsyncData([...currentList, ...more]);
    } catch (e) {
      _page--;
    }
  }

  bool get hasMore => _hasMore;
}

final propertiesProvider =
    AsyncNotifierProvider<PropertiesNotifier, List<PropertyModel>>(
  PropertiesNotifier.new,
);

// Single Property Provider
final propertyDetailProvider =
    FutureProvider.family<PropertyModel, String>((ref, id) async {
  final repository = ref.read(propertyRepositoryProvider);
  return repository.getPropertyById(id);
});
