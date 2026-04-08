import 'package:dio/dio.dart';
import '../../models/models.dart';

abstract class UnitRemoteDataSource {
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

class UnitRemoteDataSourceImpl implements UnitRemoteDataSource {
  final Dio _dio;

  UnitRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<PaginatedResponse<UnitModel>> getUnits({
    required String propertyId,
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final response = await _dio.get(
      '/properties/$propertyId/units',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (status != null) 'status': status,
      },
    );
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      UnitModel.fromJson,
    );
  }

  @override
  Future<UnitModel> getUnitById(String id) async {
    final response = await _dio.get('/units/$id');
    return UnitModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UnitModel> createUnit(Map<String, dynamic> data) async {
    final response = await _dio.post('/units', data: data);
    return UnitModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UnitModel> updateUnit(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/units/$id', data: data);
    return UnitModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteUnit(String id) async {
    await _dio.delete('/units/$id');
  }
}
