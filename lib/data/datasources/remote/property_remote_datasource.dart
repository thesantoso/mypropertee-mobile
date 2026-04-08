import 'package:dio/dio.dart';
import '../../models/models.dart';

abstract class PropertyRemoteDataSource {
  Future<PaginatedResponse<PropertyModel>> getProperties({
    int page = 1,
    int pageSize = 20,
  });
  Future<PropertyModel> getPropertyById(String id);
  Future<PropertyModel> createProperty(Map<String, dynamic> data);
  Future<PropertyModel> updateProperty(String id, Map<String, dynamic> data);
  Future<void> deleteProperty(String id);
}

class PropertyRemoteDataSourceImpl implements PropertyRemoteDataSource {
  final Dio _dio;

  PropertyRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<PaginatedResponse<PropertyModel>> getProperties({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      '/properties',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      PropertyModel.fromJson,
    );
  }

  @override
  Future<PropertyModel> getPropertyById(String id) async {
    final response = await _dio.get('/properties/$id');
    return PropertyModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PropertyModel> createProperty(Map<String, dynamic> data) async {
    final response = await _dio.post('/properties', data: data);
    return PropertyModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PropertyModel> updateProperty(
      String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/properties/$id', data: data);
    return PropertyModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteProperty(String id) async {
    await _dio.delete('/properties/$id');
  }
}
