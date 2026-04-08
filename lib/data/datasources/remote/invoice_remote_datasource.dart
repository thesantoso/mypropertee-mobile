import 'package:dio/dio.dart';
import '../../models/models.dart';

abstract class InvoiceRemoteDataSource {
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

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final Dio _dio;

  InvoiceRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<PaginatedResponse<InvoiceModel>> getInvoices({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? propertyId,
  }) async {
    final response = await _dio.get(
      '/invoices',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (status != null) 'status': status,
        if (propertyId != null) 'property_id': propertyId,
      },
    );
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      InvoiceModel.fromJson,
    );
  }

  @override
  Future<InvoiceModel> getInvoiceById(String id) async {
    final response = await _dio.get('/invoices/$id');
    return InvoiceModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<InvoiceModel> createInvoice(Map<String, dynamic> data) async {
    final response = await _dio.post('/invoices', data: data);
    return InvoiceModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<InvoiceModel> updateInvoice(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/invoices/$id', data: data);
    return InvoiceModel.fromJson(response.data as Map<String, dynamic>);
  }
}
