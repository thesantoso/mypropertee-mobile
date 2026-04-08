import '../models/models.dart';
import '../datasources/remote/incident_remote_datasource.dart';

abstract class IncidentRepository {
  Future<PaginatedResponse<IncidentModel>> getIncidents({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? propertyId,
  });
  Future<IncidentModel> getIncidentById(String id);
  Future<IncidentModel> createIncident(Map<String, dynamic> data);
  Future<IncidentModel> updateIncident(String id, Map<String, dynamic> data);
}

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentRemoteDataSource _remoteDataSource;

  IncidentRepositoryImpl({required IncidentRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<PaginatedResponse<IncidentModel>> getIncidents({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? propertyId,
  }) =>
      _remoteDataSource.getIncidents(
        page: page,
        pageSize: pageSize,
        status: status,
        propertyId: propertyId,
      );

  @override
  Future<IncidentModel> getIncidentById(String id) =>
      _remoteDataSource.getIncidentById(id);

  @override
  Future<IncidentModel> createIncident(Map<String, dynamic> data) =>
      _remoteDataSource.createIncident(data);

  @override
  Future<IncidentModel> updateIncident(String id, Map<String, dynamic> data) =>
      _remoteDataSource.updateIncident(id, data);
}
