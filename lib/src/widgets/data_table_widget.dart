import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../models/column_def.dart';
import '../models/row_selection_state.dart';
import 'sort_indicator.dart';

/// Renders the actual scrollable data grid (header, rows and totals) for a
/// set of [columns] and [data].
///
/// This is the low-level grid used internally by [DynamicDataTable]; it is
/// exported for advanced use cases that compose the table manually.
class DataTableWidget<T> extends StatelessWidget {
  /// The visible columns to render.
  final List<ColumnDef<T>> columns;

  /// The rows to render.
  final List<T> data;

  /// Height of each data row in logical pixels.
  final double rowHeight;

  /// Minimum table width before horizontal scrolling.
  final double minWidth;

  /// Called when a row is tapped, with the item and its 1-based index.
  final void Function(T item, int index)? onRowTap;

  /// Active column filters, used to highlight filtered columns.
  final Map<String, Set<String>> activeFilters;

  /// Called when a column's filter button is pressed.
  final void Function(ColumnDef<T> column) onFilterPressed;

  /// Whether per-row selection checkboxes are shown.
  final bool enableRowSelection;

  /// The current row selection state.
  final RowSelectionState<T>? selectedRows;

  /// Called when a row's selection checkbox is toggled, with its index.
  final void Function(int index)? onRowSelectionChanged;

  /// Called when the header "select all" checkbox is toggled.
  final void Function()? onSelectAllChanged;

  /// Id of the column currently sorted, if any.
  final String? activeSortColumnId;

  /// Whether the active sort is ascending.
  final bool sortAscending;

  /// Called when a column header requests a sort, with the column id.
  final void Function(String columnId)? onSort;

  /// Creates the data grid widget.
  const DataTableWidget({
    super.key,
    required this.columns,
    required this.data,
    required this.rowHeight,
    required this.minWidth,
    this.onRowTap,
    required this.activeFilters,
    required this.onFilterPressed,
    this.enableRowSelection = false,
    this.selectedRows,
    this.onRowSelectionChanged,
    this.onSelectAllChanged,
    this.activeSortColumnId,
    this.sortAscending = true,
    this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasTotals = columns.any((col) => col.totalCellBuilder != null);

    final dataRows = List.generate(data.length, (i) {
      final item = data[i];
      final isEven = (i + 1) % 2 == 0;
      final isSelected = selectedRows?.isRowSelected(i) ?? false;

      return DataRow2(
        onTap: onRowTap != null ? () => onRowTap!(item, i + 1) : null,
        selected: isSelected,
        onSelectChanged: enableRowSelection
            ? (_) {
                onRowSelectionChanged?.call(i);
              }
            : null,
        color: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return theme.colorScheme.primary.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return theme.colorScheme.primary.withValues(alpha: 0.08);
          }
          return isEven
              ? theme.colorScheme.primary.withValues(alpha: 0.04)
              : theme.colorScheme.surface;
        }),
        cells: [
          if (enableRowSelection)
            DataCell(
              Checkbox(
                value: isSelected,
                onChanged: (_) {
                  onRowSelectionChanged?.call(i);
                },
              ),
            ),
          DataCell(Text('${i + 1}', style: const TextStyle(fontSize: 12))),
          ...columns.map((col) => col.cellBuilder(item)),
        ],
      );
    });

    if (hasTotals) {
      dataRows.add(
        DataRow2(
          color: WidgetStateProperty.all(
            theme.colorScheme.primary.withValues(alpha: 0.12),
          ),
          cells: [
            DataCell(
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            ...columns.map(
              (col) => col.totalCellBuilder != null
                  ? DataCell(col.totalCellBuilder!(data))
                  : const DataCell(SizedBox.shrink()),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: DataTable2(
        scrollController: ScrollController(),
        fixedTopRows: 1,
        isHorizontalScrollBarVisible: true,
        isVerticalScrollBarVisible: true,
        dataRowHeight: rowHeight,
        headingRowHeight: rowHeight,
        minWidth: minWidth,
        columnSpacing: 12,
        horizontalMargin: 12,
        dividerThickness: 0.3,
        showBottomBorder: true,
        headingRowColor: WidgetStateProperty.all(
          theme.colorScheme.primary.withValues(alpha: 0.08),
        ),
        border: TableBorder.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
          width: 0.5,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        columns: [
          if (enableRowSelection)
            DataColumn2(
              size: ColumnSize.S,
              fixedWidth: 48,
              label: Center(
                child: Checkbox(
                  value: selectedRows?.isAllSelected ?? false,
                  onChanged: (_) {
                    onSelectAllChanged?.call();
                  },
                ),
              ),
            ),
          const DataColumn2(
            size: ColumnSize.S,
            label: Text(
              '#',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            fixedWidth: 40,
          ),
          ...columns.map(
            (col) => DataColumn2(
              size: col.size,
              minWidth: col.minWidth,
              fixedWidth: col.fixedWidth,
              onSort: col.sortable && col.onSort != null
                  ? (idx, asc) {
                      col.onSort!(idx, asc);
                      onSort?.call(col.id);
                    }
                  : null,
              tooltip: col.tooltip ?? col.label,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      col.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (col.sortable)
                    SortIndicator(
                      columnId: col.id,
                      activeSortColumnId: activeSortColumnId,
                      sortAscending: sortAscending,
                      onSort: () {
                        onSort?.call(col.id);
                      },
                    ),
                  if (col.filterable)
                    IconButton(
                      icon: Icon(
                        activeFilters.containsKey(col.id)
                            ? Icons.filter_alt
                            : Icons.filter_alt_outlined,
                        size: 16,
                        color: activeFilters.containsKey(col.id)
                            ? theme.colorScheme.primary
                            : Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: activeFilters.containsKey(col.id)
                          ? "Filter applied"
                          : "Filter",
                      onPressed: () => onFilterPressed(col),
                    ),
                ],
              ),
            ),
          ),
        ],
        rows: dataRows,
      ),
    );
  }
}
