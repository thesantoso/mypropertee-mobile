import 'package:dio/dio.dart';
import '../../models/models.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    final response = await _dio.get('/dashboard/stats');
    return DashboardStatsModel.fromJson(response.data as Map<String, dynamic>);
  }
}
