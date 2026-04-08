class PropertyModel {
  final String id;
  final String name;
  final String address;
  final String type;
  final int totalUnits;
  final int occupiedUnits;
  final String? imageUrl;
  final String? description;
  final DateTime? createdAt;

  const PropertyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.totalUnits,
    required this.occupiedUnits,
    this.imageUrl,
    this.description,
    this.createdAt,
  });

  double get occupancyRate =>
      totalUnits > 0 ? (occupiedUnits / totalUnits) * 100 : 0;

  int get vacantUnits => totalUnits - occupiedUnits;

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      type: json['type'] as String? ?? '',
      totalUnits: json['total_units'] as int? ?? 0,
      occupiedUnits: json['occupied_units'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'type': type,
      'total_units': totalUnits,
      'occupied_units': occupiedUnits,
      if (imageUrl != null) 'image_url': imageUrl,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  PropertyModel copyWith({
    String? id,
    String? name,
    String? address,
    String? type,
    int? totalUnits,
    int? occupiedUnits,
    String? imageUrl,
    String? description,
    DateTime? createdAt,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      type: type ?? this.type,
      totalUnits: totalUnits ?? this.totalUnits,
      occupiedUnits: occupiedUnits ?? this.occupiedUnits,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
