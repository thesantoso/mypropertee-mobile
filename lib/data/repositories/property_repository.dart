import '../models/models.dart';
import '../datasources/remote/property_remote_datasource.dart';

abstract class PropertyRepository {
  Future<PaginatedResponse<PropertyModel>> getProperties({
    int page = 1,
    int pageSize = 20,
  });
  Future<PropertyModel> getPropertyById(String id);
  Future<PropertyModel> createProperty(Map<String, dynamic> data);
  Future<PropertyModel> updateProperty(String id, Map<String, dynamic> data);
  Future<void> deleteProperty(String id);
}

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyRemoteDataSource _remoteDataSource;

  PropertyRepositoryImpl({required PropertyRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<PaginatedResponse<PropertyModel>> getProperties({
    int page = 1,
    int pageSize = 20,
  }) =>
      _remoteDataSource.getProperties(page: page, pageSize: pageSize);

  @override
  Future<PropertyModel> getPropertyById(String id) =>
      _remoteDataSource.getPropertyById(id);

  @override
  Future<PropertyModel> createProperty(Map<String, dynamic> data) =>
      _remoteDataSource.createProperty(data);

  @override
  Future<PropertyModel> updateProperty(String id, Map<String, dynamic> data) =>
      _remoteDataSource.updateProperty(id, data);

  @override
  Future<void> deleteProperty(String id) =>
      _remoteDataSource.deleteProperty(id);
}
