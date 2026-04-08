import 'package:flutter_test/flutter_test.dart';
import 'package:mypropertee/data/models/models.dart';

void main() {
  group('PropertyModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': '1',
        'name': 'Test Property',
        'address': '123 Test St',
        'type': 'Apartment',
        'total_units': 10,
        'occupied_units': 8,
      };
      final property = PropertyModel.fromJson(json);
      expect(property.id, '1');
      expect(property.name, 'Test Property');
      expect(property.totalUnits, 10);
      expect(property.occupiedUnits, 8);
      expect(property.vacantUnits, 2);
      expect(property.occupancyRate, 80.0);
    });

    test('copyWith creates new instance with updated fields', () {
      const property = PropertyModel(
        id: '1',
        name: 'Old Name',
        address: 'Old Address',
        type: 'Apartment',
        totalUnits: 10,
        occupiedUnits: 5,
      );
      final updated = property.copyWith(name: 'New Name');
      expect(updated.name, 'New Name');
      expect(updated.address, 'Old Address');
    });
  });

  group('InvoiceModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'inv-1',
        'invoice_number': 'INV-001',
        'property_id': 'prop-1',
        'unit_id': 'unit-1',
        'tenant_id': 'tenant-1',
        'tenant_name': 'John Doe',
        'amount': 1500000.0,
        'status': 'unpaid',
        'due_date': '2024-12-31T00:00:00.000Z',
      };
      final invoice = InvoiceModel.fromJson(json);
      expect(invoice.id, 'inv-1');
      expect(invoice.invoiceNumber, 'INV-001');
      expect(invoice.amount, 1500000.0);
      expect(invoice.status, InvoiceStatus.unpaid);
    });
  });

  group('DashboardStatsModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'total_properties': 5,
        'total_units': 50,
        'occupied_units': 40,
        'active_invoices': 10,
        'pending_incidents': 3,
        'total_revenue': 50000000.0,
        'pending_revenue': 5000000.0,
      };
      final stats = DashboardStatsModel.fromJson(json);
      expect(stats.totalProperties, 5);
      expect(stats.occupancyRate, 80.0);
    });

    test('placeholder has zero values', () {
      final placeholder = DashboardStatsModel.placeholder;
      expect(placeholder.totalProperties, 0);
      expect(placeholder.occupancyRate, 0.0);
    });
  });

  group('UnitModel', () {
    test('status parses from json', () {
      final json = {
        'id': 'u-1',
        'property_id': 'p-1',
        'unit_number': 'A-101',
        'type': 'Studio',
        'status': 'occupied',
      };
      final unit = UnitModel.fromJson(json);
      expect(unit.status, UnitStatus.occupied);
    });

    test('unknown status defaults to vacant', () {
      final json = {
        'id': 'u-1',
        'property_id': 'p-1',
        'unit_number': 'A-101',
        'type': 'Studio',
        'status': 'unknown_status',
      };
      final unit = UnitModel.fromJson(json);
      expect(unit.status, UnitStatus.vacant);
    });
  });

  group('PaginatedResponse', () {
    test('parses items and pagination correctly', () {
      final json = {
        'data': [
          {
            'id': '1',
            'name': 'Property 1',
            'address': 'Addr 1',
            'type': 'Apartment',
            'total_units': 10,
            'occupied_units': 5,
          },
        ],
        'total': 100,
        'page': 1,
        'page_size': 20,
      };
      final response = PaginatedResponse.fromJson(
        json,
        PropertyModel.fromJson,
      );
      expect(response.items.length, 1);
      expect(response.total, 100);
      expect(response.hasNextPage, true);
      expect(response.hasPreviousPage, false);
      expect(response.totalPages, 5);
    });
  });
}
