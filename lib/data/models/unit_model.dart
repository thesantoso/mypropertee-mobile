enum UnitStatus { occupied, vacant, maintenance }

class UnitModel {
  final String id;
  final String propertyId;
  final String unitNumber;
  final String type;
  final UnitStatus status;
  final double? monthlyRent;
  final int? floorArea;
  final String? tenantId;
  final String? tenantName;
  final DateTime? leaseStart;
  final DateTime? leaseEnd;

  const UnitModel({
    required this.id,
    required this.propertyId,
    required this.unitNumber,
    required this.type,
    required this.status,
    this.monthlyRent,
    this.floorArea,
    this.tenantId,
    this.tenantName,
    this.leaseStart,
    this.leaseEnd,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'] as String? ?? '',
      propertyId: json['property_id'] as String? ?? '',
      unitNumber: json['unit_number'] as String? ?? '',
      type: json['type'] as String? ?? '',
      status: UnitStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'vacant'),
        orElse: () => UnitStatus.vacant,
      ),
      monthlyRent: (json['monthly_rent'] as num?)?.toDouble(),
      floorArea: json['floor_area'] as int?,
      tenantId: json['tenant_id'] as String?,
      tenantName: json['tenant_name'] as String?,
      leaseStart: json['lease_start'] != null
          ? DateTime.tryParse(json['lease_start'] as String)
          : null,
      leaseEnd: json['lease_end'] != null
          ? DateTime.tryParse(json['lease_end'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'unit_number': unitNumber,
      'type': type,
      'status': status.name,
      if (monthlyRent != null) 'monthly_rent': monthlyRent,
      if (floorArea != null) 'floor_area': floorArea,
      if (tenantId != null) 'tenant_id': tenantId,
      if (tenantName != null) 'tenant_name': tenantName,
      if (leaseStart != null) 'lease_start': leaseStart!.toIso8601String(),
      if (leaseEnd != null) 'lease_end': leaseEnd!.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
