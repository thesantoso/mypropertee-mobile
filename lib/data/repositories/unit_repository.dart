import '../models/models.dart';
import '../datasources/remote/unit_remote_datasource.dart';

abstract class UnitRepository {
  Future<PaginatedResponse<UnitModel>> getUnits({
    required String propertyId,
    int page = 1,
    int pageSize = 20,
    String? status,
  });
  Future<UnitModel> getUnitById(String id);
  Future<UnitModel> createUnit(Map<String, dynamic> data);
  Future<UnitModel> updateUnit(String id, Map<String, dynamic> data);
  Future<void> deleteUnit(String id);
}

class UnitRepositoryImpl implements UnitRepository {
  final UnitRemoteDataSource _remoteDataSource;

  UnitRepositoryImpl({required UnitRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<PaginatedResponse<UnitModel>> getUnits({
    required String propertyId,
    int page = 1,
    int pageSize = 20,
    String? status,
  }) =>
      _remoteDataSource.getUnits(
        propertyId: propertyId,
        page: page,
        pageSize: pageSize,
        status: status,
      );

  @override
  Future<UnitModel> getUnitById(String id) =>
      _remoteDataSource.getUnitById(id);

  @override
  Future<UnitModel> createUnit(Map<String, dynamic> data) =>
      _remoteDataSource.createUnit(data);

  @override
  Future<UnitModel> updateUnit(String id, Map<String, dynamic> data) =>
      _remoteDataSource.updateUnit(id, data);

  @override
  Future<void> deleteUnit(String id) => _remoteDataSource.deleteUnit(id);
}
