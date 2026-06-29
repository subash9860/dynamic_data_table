import 'package:flutter/material.dart';
import '../models/date_filter_model.dart';
import 'table_date_filter.dart';
import 'table_search_field.dart';
import '../models/table_config.dart';

/// The header bar above the table: title, search field, optional date filter,
/// column picker and export controls. Responsive between mobile and desktop.
class DynamicTableHeader extends StatelessWidget {
  /// Optional table title shown on the left.
  final String? tableName;

  /// Controller for the search text field.
  final TextEditingController searchController;

  /// Called when the search text changes.
  final ValueChanged<String> onSearchChanged;

  /// Called when the search field is cleared.
  final VoidCallback onClearSearch;

  /// Whether the search field currently has text.
  final bool hasSearchText;

  /// Called when the column picker button is pressed.
  final VoidCallback onColumnPicker;

  /// Number of currently visible columns (for the "Columns (x/y)" label).
  final int visibleColumnsCount;

  /// Total number of columns (for the "Columns (x/y)" label).
  final int totalColumnsCount;

  /// Called when the export button is pressed.
  final VoidCallback onExport;

  /// Whether the date filter control is shown.
  final bool enableDateFilter;

  /// The current date filter value, if any.
  final DateFilterValue? dateFilterValue;

  /// Called when the date filter changes (or is cleared with `null`).
  final ValueChanged<DateFilterValue?>? onDateFilterChanged;

  /// UI labels and feature toggles for the header.
  final TableConfig config;

  /// Creates the table header bar.
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
      width: isMobile ? null : 320,
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

    // Desktop: icon + title leftmost, search + controls grouped rightmost.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          const SizedBox(width: 16),
          // Search + controls grouped at right.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              searchField,
              if (dateFilter != null) ...[
                const SizedBox(width: 8),
                dateFilter,
              ],
              const SizedBox(width: 8),
              columnsButton,
              if (exportButton != null) ...[
                const SizedBox(width: 4),
                exportButton,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
