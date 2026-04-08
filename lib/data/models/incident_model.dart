enum IncidentStatus { open, inProgress, resolved, closed }
enum IncidentPriority { low, medium, high, critical }

class IncidentModel {
  final String id;
  final String propertyId;
  final String unitId;
  final String title;
  final String description;
  final IncidentStatus status;
  final IncidentPriority priority;
  final String? reportedBy;
  final String? assignedTo;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const IncidentModel({
    required this.id,
    required this.propertyId,
    required this.unitId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.reportedBy,
    this.assignedTo,
    required this.createdAt,
    this.resolvedAt,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'] as String? ?? '',
      propertyId: json['property_id'] as String? ?? '',
      unitId: json['unit_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: IncidentStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'open'),
        orElse: () => IncidentStatus.open,
      ),
      priority: IncidentPriority.values.firstWhere(
        (e) => e.name == (json['priority'] as String? ?? 'medium'),
        orElse: () => IncidentPriority.medium,
      ),
      reportedBy: json['reported_by'] as String?,
      assignedTo: json['assigned_to'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.tryParse(json['resolved_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'unit_id': unitId,
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      if (reportedBy != null) 'reported_by': reportedBy,
      if (assignedTo != null) 'assigned_to': assignedTo,
      'created_at': createdAt.toIso8601String(),
      if (resolvedAt != null) 'resolved_at': resolvedAt!.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncidentModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
