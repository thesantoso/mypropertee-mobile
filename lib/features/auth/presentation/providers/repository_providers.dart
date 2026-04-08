import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/datasources/remote/dashboard_remote_datasource.dart';
import '../../../../data/datasources/remote/incident_remote_datasource.dart';
import '../../../../data/datasources/remote/invoice_remote_datasource.dart';
import '../../../../data/datasources/remote/payment_remote_datasource.dart';
import '../../../../data/datasources/remote/property_remote_datasource.dart';
import '../../../../data/datasources/remote/unit_remote_datasource.dart';
import '../../../../data/repositories/dashboard_repository.dart';
import '../../../../data/repositories/incident_repository.dart';
import '../../../../data/repositories/invoice_repository.dart';
import '../../../../data/repositories/payment_repository.dart';
import '../../../../data/repositories/property_repository.dart';
import '../../../../data/repositories/unit_repository.dart';
import 'dio_provider.dart';

// Data Sources
final dashboardRemoteDataSourceProvider =
    Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final propertyRemoteDataSourceProvider =
    Provider<PropertyRemoteDataSource>((ref) {
  return PropertyRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final unitRemoteDataSourceProvider = Provider<UnitRemoteDataSource>((ref) {
  return UnitRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final invoiceRemoteDataSourceProvider =
    Provider<InvoiceRemoteDataSource>((ref) {
  return InvoiceRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final paymentRemoteDataSourceProvider =
    Provider<PaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final incidentRemoteDataSourceProvider =
    Provider<IncidentRemoteDataSource>((ref) {
  return IncidentRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

// Repositories
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
      remoteDataSource: ref.watch(dashboardRemoteDataSourceProvider));
});

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  return PropertyRepositoryImpl(
      remoteDataSource: ref.watch(propertyRemoteDataSourceProvider));
});

final unitRepositoryProvider = Provider<UnitRepository>((ref) {
  return UnitRepositoryImpl(
      remoteDataSource: ref.watch(unitRemoteDataSourceProvider));
});

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepositoryImpl(
      remoteDataSource: ref.watch(invoiceRemoteDataSourceProvider));
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(
      remoteDataSource: ref.watch(paymentRemoteDataSourceProvider));
});

final incidentRepositoryProvider = Provider<IncidentRepository>((ref) {
  return IncidentRepositoryImpl(
      remoteDataSource: ref.watch(incidentRemoteDataSourceProvider));
});
