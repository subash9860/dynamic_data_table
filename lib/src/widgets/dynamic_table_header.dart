import 'package:flutter/material.dart';
import '../models/date_filter_model.dart';
import 'table_date_filter.dart';
import 'table_search_field.dart';
import '../models/table_config.dart';

class DynamicTableHeader extends StatelessWidget {
  final String? tableName;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final bool hasSearchText;
  final VoidCallback onColumnPicker;
  final int visibleColumnsCount;
  final int totalColumnsCount;
  final VoidCallback onExport;

  final bool enableDateFilter;
  final DateFilterValue? dateFilterValue;
  final ValueChanged<DateFilterValue?>? onDateFilterChanged;

  final TableConfig config;

  const DynamicTableHeader({
    super.key,
    this.tableName,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.hasSearchText,
    required this.onColumnPicker,
    required this.visibleColumnsCount,
    required this.totalColumnsCount,
    required this.onExport,
    required this.config,
    this.enableDateFilter = false,
    this.dateFilterValue,
    this.onDateFilterChanged,
  });

  bool get _canExport => config.canExport?.call() ?? true;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (!isMobile && tableName != null && tableName!.isNotEmpty)
            Text(
              tableName!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          Flexible(
            child: TableSearchField(
              controller: searchController,
              onChanged: onSearchChanged,
              onClear: onClearSearch,
              hasText: hasSearchText,
              hintText: config.searchHint,
            ),
          ),
          if (enableDateFilter && onDateFilterChanged != null)
            TableDateFilter(
              value: dateFilterValue,
              onChanged: onDateFilterChanged!,
            ),
          TextButton.icon(
            onPressed: onColumnPicker,
            icon: const Icon(Icons.view_column_outlined, size: 18),
            label: Text(
              'Columns ($visibleColumnsCount/$totalColumnsCount)',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (_canExport)
            IconButton(
              onPressed: onExport,
              tooltip: config.exportLabel,
              icon: const Icon(Icons.download, size: 18),
            ),
        ],
      ),
    );
  }
}
