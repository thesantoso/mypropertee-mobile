import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/models.dart';
import '../../../../data/repositories/unit_repository.dart';
import '../../../auth/presentation/providers/repository_providers.dart';

final unitsProvider = AsyncNotifierProviderFamily<UnitsNotifier,
    List<UnitModel>, String>(UnitsNotifier.new);

class UnitsNotifier extends FamilyAsyncNotifier<List<UnitModel>, String> {
  @override
  Future<List<UnitModel>> build(String propertyId) async {
    final repository = ref.read(unitRepositoryProvider);
    final result = await repository.getUnits(propertyId: propertyId);
    return result.items;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(unitRepositoryProvider);
      final result = await repository.getUnits(propertyId: arg);
      return result.items;
    });
  }
}

final unitDetailProvider =
    FutureProvider.family<UnitModel, String>((ref, id) async {
  final repository = ref.read(unitRepositoryProvider);
  return repository.getUnitById(id);
});
