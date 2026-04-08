enum InvoiceStatus { paid, unpaid, overdue, cancelled }

class InvoiceModel {
  final String id;
  final String invoiceNumber;
  final String propertyId;
  final String unitId;
  final String tenantId;
  final String tenantName;
  final double amount;
  final InvoiceStatus status;
  final DateTime dueDate;
  final DateTime? paidAt;
  final String? description;

  const InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.propertyId,
    required this.unitId,
    required this.tenantId,
    required this.tenantName,
    required this.amount,
    required this.status,
    required this.dueDate,
    this.paidAt,
    this.description,
  });

  bool get isOverdue =>
      status == InvoiceStatus.unpaid && dueDate.isBefore(DateTime.now());

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as String? ?? '',
      invoiceNumber: json['invoice_number'] as String? ?? '',
      propertyId: json['property_id'] as String? ?? '',
      unitId: json['unit_id'] as String? ?? '',
      tenantId: json['tenant_id'] as String? ?? '',
      tenantName: json['tenant_name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: InvoiceStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'unpaid'),
        orElse: () => InvoiceStatus.unpaid,
      ),
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : DateTime.now(),
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'] as String)
          : null,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'property_id': propertyId,
      'unit_id': unitId,
      'tenant_id': tenantId,
      'tenant_name': tenantName,
      'amount': amount,
      'status': status.name,
      'due_date': dueDate.toIso8601String(),
      if (paidAt != null) 'paid_at': paidAt!.toIso8601String(),
      if (description != null) 'description': description,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
