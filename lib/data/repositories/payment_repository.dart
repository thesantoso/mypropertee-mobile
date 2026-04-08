import '../models/models.dart';
import '../datasources/remote/payment_remote_datasource.dart';

abstract class PaymentRepository {
  Future<PaginatedResponse<PaymentModel>> getPayments({
    int page = 1,
    int pageSize = 20,
    String? invoiceId,
  });
  Future<PaymentModel> createPayment(Map<String, dynamic> data);
  Future<PaymentModel> getPaymentById(String id);
}

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImpl({required PaymentRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<PaginatedResponse<PaymentModel>> getPayments({
    int page = 1,
    int pageSize = 20,
    String? invoiceId,
  }) =>
      _remoteDataSource.getPayments(
        page: page,
        pageSize: pageSize,
        invoiceId: invoiceId,
      );

  @override
  Future<PaymentModel> createPayment(Map<String, dynamic> data) =>
      _remoteDataSource.createPayment(data);

  @override
  Future<PaymentModel> getPaymentById(String id) =>
      _remoteDataSource.getPaymentById(id);
}
