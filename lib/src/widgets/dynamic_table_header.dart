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
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    final searchField = TableSearchField(
      controller: searchController,
      onChanged: onSearchChanged,
      onClear: onClearSearch,
      hasText: hasSearchText,
      hintText: config.searchHint,
      width: isMobile ? null : double.infinity,
    );

    final dateFilter = (enableDateFilter && onDateFilterChanged != null)
        ? TableDateFilter(
            value: dateFilterValue,
            onChanged: onDateFilterChanged!,
          )
        : null;

    final columnsButton = TextButton.icon(
      onPressed: onColumnPicker,
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
      ),
      icon: const Icon(Icons.view_column_outlined, size: 18),
      label: Text(
        'Columns ($visibleColumnsCount/$totalColumnsCount)',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );

    final exportButton = _canExport
        ? IconButton(
            onPressed: onExport,
            tooltip: config.exportLabel,
            color: theme.colorScheme.primary,
            icon: const Icon(Icons.download, size: 18),
          )
        : null;

    // Mobile: search on top, controls wrap below.
    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            searchField,
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (dateFilter != null) dateFilter,
                columnsButton,
                if (exportButton != null) exportButton,
              ],
            ),
          ],
        ),
      );
    }

    // Desktop: icon + title left, search centered, controls right.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (tableName != null && tableName!.isNotEmpty)
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.table_chart_rounded,
                    size: 22,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      tableName!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox.shrink(),
          // Centered search between title and controls.
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: searchField,
              ),
            ),
          ),
          if (dateFilter != null) ...[
            dateFilter,
            const SizedBox(width: 8),
          ],
          columnsButton,
          if (exportButton != null) ...[
            const SizedBox(width: 4),
            exportButton,
          ],
        ],
      ),
    );
  }
}
