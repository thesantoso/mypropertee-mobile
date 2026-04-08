enum PaymentStatus { pending, success, failed, expired, cancelled }
enum PaymentMethod { transfer, virtualAccount, creditCard, ewallet, qris }

class PaymentModel {
  final String id;
  final String invoiceId;
  final String invoiceNumber;
  final double amount;
  final PaymentStatus status;
  final PaymentMethod? method;
  final String? transactionId;
  final String? paymentUrl;
  final DateTime createdAt;
  final DateTime? completedAt;

  const PaymentModel({
    required this.id,
    required this.invoiceId,
    required this.invoiceNumber,
    required this.amount,
    required this.status,
    this.method,
    this.transactionId,
    this.paymentUrl,
    required this.createdAt,
    this.completedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String? ?? '',
      invoiceId: json['invoice_id'] as String? ?? '',
      invoiceNumber: json['invoice_number'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'pending'),
        orElse: () => PaymentStatus.pending,
      ),
      method: json['method'] != null
          ? PaymentMethod.values.firstWhere(
              (e) => e.name == json['method'] as String,
              orElse: () => PaymentMethod.transfer,
            )
          : null,
      transactionId: json['transaction_id'] as String?,
      paymentUrl: json['payment_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'invoice_number': invoiceNumber,
      'amount': amount,
      'status': status.name,
      if (method != null) 'method': method!.name,
      if (transactionId != null) 'transaction_id': transactionId,
      if (paymentUrl != null) 'payment_url': paymentUrl,
      'created_at': createdAt.toIso8601String(),
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
