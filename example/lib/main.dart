// Example: Using Enhanced DynamicDataTable with All Features

import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dynamic_data_table/dynamic_data_table.dart';

class Item {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final DateTime createdAt;
  final String status;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.createdAt,
    required this.status,
  });
}

class DynamicTableExample extends StatefulWidget {
  const DynamicTableExample({super.key});

  @override
  State<DynamicTableExample> createState() => _DynamicTableExampleState();
}

class _DynamicTableExampleState extends State<DynamicTableExample> {
  late List<Item> items;
  TableLoadingState loadingState = TableLoadingState.idle;
  String? errorMessage;
  List<Item> selectedItems = [];
  Pagination? pagination;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() => loadingState = TableLoadingState.loading);

    // Simulate network request
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          items = [
            Item(
              id: '1',
              name: 'Widget A',
              price: 99.99,
              quantity: 50,
              createdAt: DateTime.now().subtract(const Duration(days: 5)),
              status: 'Active',
            ),
            Item(
              id: '2',
              name: 'Widget B',
              price: 149.99,
              quantity: 30,
              createdAt: DateTime.now().subtract(const Duration(days: 10)),
              status: 'Inactive',
            ),
            Item(
              id: '3',
              name: 'Widget C',
              price: 199.99,
              quantity: 100,
              createdAt: DateTime.now(),
              status: 'Active',
            ),
          ];
          pagination = Pagination(
            page: 1,
            limit: 25,
            totalRows: 3,
            totalPages: 1,
          );
          loadingState = TableLoadingState.idle;
        });
      }
    });
  }

  void _handleError() {
    setState(() {
      loadingState = TableLoadingState.error;
      errorMessage = 'Failed to fetch items. Please try again.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Table Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Show selected count if any
            if (selectedItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedItems.length} item(s) selected',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Selected: ${selectedItems.map((e) => e.name).join(", ")}',
                            ),
                          ),
                        );
                      },
                      child: const Text('Perform Action'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            // Main data table with all features
            Expanded(
              child: DynamicDataTable<Item>(
                // Core data
                data: items,
                tableName: 'Products Inventory',
                columns: _buildColumns(),

                // New features
                enableRowSelection: true,
                onRowSelectionChanged: (selected) {
                  setState(() => selectedItems = selected);
                },

                // Loading & error states
                loadingState: loadingState,
                errorMessage: errorMessage,

                // Configuration
                config: TableConfig(
                  searchHint: 'Search by name or ID...',
                  filterLabel: 'Filter by Status',
                  exportLabel: 'Download Excel',
                  selectAllLabel: 'Select All Items',
                  applyLabel: 'Apply Filters',
                  cancelLabel: 'Cancel',
                  enableRowSelection: true,
                  enableLoadingState: true,
                  enableSortIndicators: true,
                  canExport: () {
                    // Check permission
                    return true; // Replace with actual permission check
                  },
                ),

                // Search & filter
                onSearch: (searchTerm) {
                  // Handle remote search if needed
                  debugPrint('Searching: $searchTerm');
                },
                searchStringBuilder: (item) => '${item.name} ${item.id}',

                // Pagination
                pagination: pagination,
                onPageChanged: (newPage, pageSize) {
                  setState(() => currentPage = newPage);
                  _loadData(); // Reload with new page
                },

                // Row tap
                onRowTap: (item, rowIndex) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tapped: ${item.name}')),
                  );
                },

                // Empty state
                emptyState: () => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No items found',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                // Date filter
                enableDateFilter: true,
                onDateFilterChanged: (dateFilter) {
                  // Handle date filter
                  debugPrint('Date filter: $dateFilter');
                },
              ),
            ),
            const SizedBox(height: 16),
            // Debug controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload'),
                ),
                ElevatedButton.icon(
                  onPressed: _handleError,
                  icon: const Icon(Icons.error),
                  label: const Text('Trigger Error'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<ColumnDef<Item>> _buildColumns() {
    return [
      ColumnDef<Item>(
        id: 'name',
        label: 'Product Name',
        sortable: true,
        exportable: true,
        filterable: true,
        cellBuilder: (item) => DataCell(Text(item.name)),
        filterValueBuilder: (item) => item.name,
        exportValueBuilder: (item) => item.name,
        size: ColumnSize.L,
        onSort: (idx, asc) => debugPrint('Sort by name: ${asc ? "ASC" : "DESC"}'),
      ),
      ColumnDef<Item>(
        id: 'price',
        label: 'Price',
        sortable: true,
        exportable: true,
        cellBuilder: (item) => DataCell(
          Text('\$${item.price.toStringAsFixed(2)}'),
        ),
        exportValueBuilder: (item) => item.price.toStringAsFixed(2),
        size: ColumnSize.M,
        onSort: (idx, asc) => debugPrint('Sort by price: ${asc ? "ASC" : "DESC"}'),
      ),
      ColumnDef<Item>(
        id: 'quantity',
        label: 'Quantity',
        sortable: true,
        exportable: true,
        cellBuilder: (item) => DataCell(Text('${item.quantity}')),
        exportValueBuilder: (item) => '${item.quantity}',
        size: ColumnSize.S,
        onSort: (idx, asc) =>
            debugPrint('Sort by quantity: ${asc ? "ASC" : "DESC"}'),
      ),
      ColumnDef<Item>(
        id: 'status',
        label: 'Status',
        sortable: true,
        exportable: true,
        filterable: true,
        cellBuilder: (item) => DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: item.status == 'Active'
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.status,
              style: TextStyle(
                color: item.status == 'Active' ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ),
        filterValueBuilder: (item) => item.status,
        exportValueBuilder: (item) => item.status,
        size: ColumnSize.M,
        onSort: (idx, asc) => debugPrint('Sort by status: ${asc ? "ASC" : "DESC"}'),
      ),
      ColumnDef<Item>(
        id: 'createdAt',
        label: 'Created',
        sortable: true,
        exportable: true,
        cellBuilder: (item) => DataCell(
          Text(
            '${item.createdAt.year}-${item.createdAt.month.toString().padLeft(2, "0")}-${item.createdAt.day.toString().padLeft(2, "0")}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        exportValueBuilder: (item) =>
            '${item.createdAt.year}-${item.createdAt.month}-${item.createdAt.day}',
        size: ColumnSize.M,
        onSort: (idx, asc) =>
            debugPrint('Sort by createdAt: ${asc ? "ASC" : "DESC"}'),
      ),
    ];
  }
}

// Key Features Demonstrated:

// 1. ROW SELECTION
//    - enableRowSelection: true
//    - onRowSelectionChanged callback
//    - Selected items displayed in badge

// 2. LOADING STATE
//    - loadingState: TableLoadingState.loading
//    - Shows spinner overlay

// 3. ERROR STATE
//    - loadingState: TableLoadingState.error
//    - errorMessage displayed with icon

// 4. SORT INDICATORS
//    - Column.sortable = true
//    - Visual up/down arrows in header
//    - Click to toggle ascending/descending

// 5. SEARCH & FILTER
//    - searchStringBuilder for local search
//    - filterable columns with dropdown
//    - onSearch for remote search

// 6. CUSTOM CONFIG
//    - TableConfig for all strings
//    - canExport callback for permissions
//    - Feature flags (enableLoadingState, etc.)

// 7. PAGINATION
//    - pagination object with page info
//    - onPageChanged callback
//    - Previous/Next/Page selector

// 8. ROW ACTIONS
//    - onRowTap for row click handling
//    - Custom emptyState widget

// 9. DATE FILTER
//    - enableDateFilter: true
//    - onDateFilterChanged callback
//    - Calendar picker UI

// 10. COLUMN CUSTOMIZATION
//     - sortable, filterable, exportable flags
//     - Custom cell builders
//     - Filter/export value builders
//     - Total row support via totalCellBuilder
