import '../models/models.dart';
import '../datasources/remote/dashboard_remote_datasource.dart';

abstract class DashboardRepository {
  Future<DashboardStatsModel> getDashboardStats();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl({required DashboardRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<DashboardStatsModel> getDashboardStats() =>
      _remoteDataSource.getDashboardStats();
}
