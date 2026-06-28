import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_data_table/dynamic_data_table.dart';

class TestItem {
  final String id;
  final String name;
  final String email;

  TestItem({
    required this.id,
    required this.name,
    required this.email,
  });
}

void main() {
  group('ColumnDef', () {
    test('creates column definition with required fields', () {
      final column = ColumnDef<TestItem>(
        id: 'name',
        label: 'Name',
        cellBuilder: (item) => DataCell(Text(item.name)),
      );

      expect(column.id, 'name');
      expect(column.label, 'Name');
      expect(column.sortable, true);
      expect(column.exportable, true);
    });

    test('supports sortable flag', () {
      final column = ColumnDef<TestItem>(
        id: 'email',
        label: 'Email',
        cellBuilder: (item) => DataCell(Text(item.email)),
        sortable: false,
      );

      expect(column.sortable, false);
    });

    test('supports filterable flag', () {
      final column = ColumnDef<TestItem>(
        id: 'name',
        label: 'Name',
        cellBuilder: (item) => DataCell(Text(item.name)),
        filterable: true,
      );

      expect(column.filterable, true);
    });

    test('copyWith creates new instance with overrides', () {
      final original = ColumnDef<TestItem>(
        id: 'name',
        label: 'Name',
        cellBuilder: (item) => DataCell(Text(item.name)),
      );

      final updated = original.copyWith(label: 'Full Name');

      expect(updated.id, 'name');
      expect(updated.label, 'Full Name');
      expect(original.label, 'Name');
    });
  });

  group('TableConfig', () {
    test('creates default table configuration', () {
      final config = TableConfig();

      expect(config, isNotNull);
    });
  });

  group('TestItem', () {
    test('creates test item with all fields', () {
      final item = TestItem(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
      );

      expect(item.id, '1');
      expect(item.name, 'John Doe');
      expect(item.email, 'john@example.com');
    });
  });
}
