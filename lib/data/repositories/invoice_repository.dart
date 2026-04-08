import '../models/models.dart';
import '../datasources/remote/invoice_remote_datasource.dart';

abstract class InvoiceRepository {
  Future<PaginatedResponse<InvoiceModel>> getInvoices({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? propertyId,
  });
  Future<InvoiceModel> getInvoiceById(String id);
  Future<InvoiceModel> createInvoice(Map<String, dynamic> data);
  Future<InvoiceModel> updateInvoice(String id, Map<String, dynamic> data);
}

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource _remoteDataSource;

  InvoiceRepositoryImpl({required InvoiceRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<PaginatedResponse<InvoiceModel>> getInvoices({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? propertyId,
  }) =>
      _remoteDataSource.getInvoices(
        page: page,
        pageSize: pageSize,
        status: status,
        propertyId: propertyId,
      );

  @override
  Future<InvoiceModel> getInvoiceById(String id) =>
      _remoteDataSource.getInvoiceById(id);

  @override
  Future<InvoiceModel> createInvoice(Map<String, dynamic> data) =>
      _remoteDataSource.createInvoice(data);

  @override
  Future<InvoiceModel> updateInvoice(String id, Map<String, dynamic> data) =>
      _remoteDataSource.updateInvoice(id, data);
}
