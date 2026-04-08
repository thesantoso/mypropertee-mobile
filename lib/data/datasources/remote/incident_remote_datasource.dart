import 'package:dio/dio.dart';
import '../../models/models.dart';

abstract class IncidentRemoteDataSource {
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

class IncidentRemoteDataSourceImpl implements IncidentRemoteDataSource {
  final Dio _dio;

  IncidentRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<PaginatedResponse<IncidentModel>> getIncidents({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? propertyId,
  }) async {
    final response = await _dio.get(
      '/incidents',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (status != null) 'status': status,
        if (propertyId != null) 'property_id': propertyId,
      },
    );
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      IncidentModel.fromJson,
    );
  }

  @override
  Future<IncidentModel> getIncidentById(String id) async {
    final response = await _dio.get('/incidents/$id');
    return IncidentModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<IncidentModel> createIncident(Map<String, dynamic> data) async {
    final response = await _dio.post('/incidents', data: data);
    return IncidentModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<IncidentModel> updateIncident(
      String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/incidents/$id', data: data);
    return IncidentModel.fromJson(response.data as Map<String, dynamic>);
  }
}
