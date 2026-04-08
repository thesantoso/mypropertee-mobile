class DashboardStatsModel {
  final int totalProperties;
  final int totalUnits;
  final int occupiedUnits;
  final int activeInvoices;
  final int pendingIncidents;
  final double totalRevenue;
  final double pendingRevenue;

  const DashboardStatsModel({
    required this.totalProperties,
    required this.totalUnits,
    required this.occupiedUnits,
    required this.activeInvoices,
    required this.pendingIncidents,
    required this.totalRevenue,
    required this.pendingRevenue,
  });

  double get occupancyRate =>
      totalUnits > 0 ? (occupiedUnits / totalUnits) * 100 : 0;

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalProperties: json['total_properties'] as int? ?? 0,
      totalUnits: json['total_units'] as int? ?? 0,
      occupiedUnits: json['occupied_units'] as int? ?? 0,
      activeInvoices: json['active_invoices'] as int? ?? 0,
      pendingIncidents: json['pending_incidents'] as int? ?? 0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
      pendingRevenue: (json['pending_revenue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Placeholder instance for skeleton loading
  static final placeholder = DashboardStatsModel(
    totalProperties: 0,
    totalUnits: 0,
    occupiedUnits: 0,
    activeInvoices: 0,
    pendingIncidents: 0,
    totalRevenue: 0,
    pendingRevenue: 0,
  );
}
