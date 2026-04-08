import 'package:dio/dio.dart';
import '../../models/models.dart';

abstract class PaymentRemoteDataSource {
  Future<PaginatedResponse<PaymentModel>> getPayments({
    int page = 1,
    int pageSize = 20,
    String? invoiceId,
  });
  Future<PaymentModel> createPayment(Map<String, dynamic> data);
  Future<PaymentModel> getPaymentById(String id);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<PaginatedResponse<PaymentModel>> getPayments({
    int page = 1,
    int pageSize = 20,
    String? invoiceId,
  }) async {
    final response = await _dio.get(
      '/payments',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (invoiceId != null) 'invoice_id': invoiceId,
      },
    );
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      PaymentModel.fromJson,
    );
  }

  @override
  Future<PaymentModel> createPayment(Map<String, dynamic> data) async {
    final response = await _dio.post('/payments', data: data);
    return PaymentModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PaymentModel> getPaymentById(String id) async {
    final response = await _dio.get('/payments/$id');
    return PaymentModel.fromJson(response.data as Map<String, dynamic>);
  }
}
