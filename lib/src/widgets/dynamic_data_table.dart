import 'dart:async';
import 'package:flutter/material.dart';
import 'today_sale_excel_exporter.dart';
import '../models/pagination_response.dart';
import '../models/column_def.dart';
import '../models/date_filter_model.dart';
import 'table_footer.dart';
import 'column_picker_dialog.dart';
import 'data_table_widget.dart';
import 'dynamic_table_header.dart';
import 'filter_dialog.dart';
import '../utils/table_data_processor.dart';
import '../models/table_config.dart';
import '../models/row_selection_state.dart';

/// The data-loading status of a [DynamicDataTable].
enum TableLoadingState {
  /// Data is loaded and ready to display.
  idle,

  /// Data is currently being fetched.
  loading,

  /// Data loading failed.
  error,
}

/// A feature-rich, generic data table with search, filtering, sorting,
/// pagination, row selection, date filtering and export.
///
/// Supply [data] and [columns] (a list of [ColumnDef]) and a [TableConfig].
/// For server-driven data, provide [pagination], [onPageChanged] and
/// optionally [onSearch].
class DynamicDataTable<T> extends StatefulWidget {
  /// The rows to display (the current page when paginated).
  final List<T> data;

  /// Pagination metadata; when set, a pagination footer is shown.
  final Pagination? pagination;

  /// Called when the user requests a different page or page size.
  final Function(int newPage, int pageSize)? onPageChanged;

  /// The column definitions describing each column.
  final List<ColumnDef<T>> columns;

  /// Builds the widget shown when there are no rows.
  final Widget Function()? emptyState;

  /// Minimum table width in logical pixels before horizontal scrolling.
  final double minWidth;

  /// Height of each data row in logical pixels.
  final double rowHeight;

  /// Called when a row is tapped, with the item and its 1-based index.
  final void Function(T item, int index)? onRowTap;

  /// Optional title shown in the table header.
  final String? tableName;

  /// Called with the search term; enables remote search when provided.
  final void Function(String searchTerm)? onSearch;

  /// Builds the searchable string for an item used by local search.
  final String Function(T item)? searchStringBuilder;

  /// Whether to show the date filter control in the header.
  final bool enableDateFilter;

  /// Called when the date filter changes (or is cleared with `null`).
  final void Function(DateFilterValue?)? onDateFilterChanged;

  /// Whether per-row selection checkboxes are shown.
  final bool enableRowSelection;

  /// Called with the currently selected items when the selection changes.
  final void Function(List<T> selectedItems)? onRowSelectionChanged;

  /// The current loading state controlling which view is rendered.
  final TableLoadingState loadingState;

  /// Message shown when [loadingState] is [TableLoadingState.error].
  final String? errorMessage;

  /// UI labels and feature toggles for the table.
  final TableConfig config;

  /// Creates a dynamic data table.
  const DynamicDataTable({
    super.key,
    required this.data,
    required this.columns,
    this.emptyState,
    this.minWidth = 700,
    this.rowHeight = 44,
    this.onRowTap,
    this.tableName,
    this.pagination,
    this.onPageChanged,
    this.onSearch,
    this.searchStringBuilder,
    this.enableDateFilter = false,
    this.onDateFilterChanged,
    this.enableRowSelection = false,
    this.onRowSelectionChanged,
    this.loadingState = TableLoadingState.idle,
    this.errorMessage,
    required this.config,
  });

  @override
  State<DynamicDataTable<T>> createState() => _DynamicDataTableState<T>();
}

class _DynamicDataTableState<T> extends State<DynamicDataTable<T>> {
  late List<ColumnDef<T>> _columns;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchTerm = '';
  final Map<String, Set<String>> _activeFilters = {};
  DateFilterValue? _dateFilter;
  late RowSelectionState<T> _selectedRows;
  String? _activeSortColumnId;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _columns = widget.columns;
    _selectedRows = RowSelectionState<T>();
  }

  @override
  void didUpdateWidget(covariant DynamicDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.columns != widget.columns) _columns = widget.columns;
    if (_searchController.text != _searchTerm) {
      _searchController.text = _searchTerm;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  bool get _allDataPresent {
    if (widget.pagination == null) return true;
    final totalRows = widget.pagination!.totalRows ?? 0;
    return widget.data.length >= totalRows && totalRows > 0;
  }

  bool get _shouldUseRemoteSearch =>
      widget.onSearch != null && !_allDataPresent;

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() => _searchTerm = value);
      if (_shouldUseRemoteSearch) widget.onSearch!.call(value);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
    if (widget.onSearch != null) widget.onSearch!.call('');
  }

  void _toggleRowSelection(int index) {
    setState(() {
      _selectedRows.toggleRow(index);
      widget.onRowSelectionChanged
          ?.call(_selectedRows.getSelectedItems(widget.data));
    });
  }

  void _selectAllRows() {
    setState(() {
      if (_selectedRows.isAllSelected) {
        _selectedRows.clearSelection();
      } else {
        _selectedRows.selectAll(widget.data.length);
      }
      widget.onRowSelectionChanged
          ?.call(_selectedRows.getSelectedItems(widget.data));
    });
  }

  void _onSortChanged(String columnId) {
    setState(() {
      if (_activeSortColumnId == columnId) {
        _sortAscending = !_sortAscending;
      } else {
        _activeSortColumnId = columnId;
        _sortAscending = true;
      }
      try {
        final column = _columns.firstWhere((col) => col.id == columnId);
        if (column.onSort != null) {
          column.onSort!(0, _sortAscending);
        }
      } catch (e) {
        // Column not found
      }
    });
  }

  void _showColumnPicker() {
    showDialog(
      context: context,
      builder: (_) => ColumnPickerDialog<T>(
        columns: _columns,
        onApply: () => setState(() {}),
      ),
    );
  }

  void _showFilterDialog(ColumnDef<T> column) {
    final processor = TableDataProcessor<T>(
      data: widget.data,
      columns: _columns,
      searchStringBuilder: widget.searchStringBuilder,
      searchTerm: _searchTerm,
      activeFilters: _activeFilters,
      useRemoteSearch: _shouldUseRemoteSearch,
    );
    final uniqueValues = processor.getUniqueValues(column);
    final initialSelected = _activeFilters[column.id] ?? {};

    showDialog(
      context: context,
      builder: (_) => FilterDialog<T>(
        column: column,
        uniqueValues: uniqueValues,
        initialSelected: initialSelected,
        onApply: (selected) {
          setState(() {
            if (selected.isEmpty) {
              _activeFilters.remove(column.id);
            } else {
              _activeFilters[column.id] = selected;
            }
          });
        },
      ),
    );
  }

  void _exportToExcel() {
    final processor = TableDataProcessor<T>(
      data: widget.data,
      columns: _columns,
      searchStringBuilder: widget.searchStringBuilder,
      searchTerm: _searchTerm,
      activeFilters: _activeFilters,
      useRemoteSearch: _shouldUseRemoteSearch,
    );
    TodaySaleExcelExporter.export(
      columns: processor.visibleColumns,
      data: processor.filteredData,
      fileName:
          "${widget.tableName?.replaceAll(" ", "_")}_${DateTime.now()}.xlsx",
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading data...',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.error.withValues(alpha: 0.05),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Error loading data',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    if (widget.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          widget.errorMessage!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Handle loading state
    if (widget.loadingState == TableLoadingState.loading) {
      return _buildLoadingState(context);
    }

    // Handle error state
    if (widget.loadingState == TableLoadingState.error) {
      return _buildErrorState(context);
    }

    final processor = TableDataProcessor<T>(
      data: widget.data,
      columns: _columns,
      searchStringBuilder: widget.searchStringBuilder,
      searchTerm: _searchTerm,
      activeFilters: _activeFilters,
      useRemoteSearch: _shouldUseRemoteSearch,
    );
    final tableData = processor.filteredData;
    final visibleColumns = processor.visibleColumns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DynamicTableHeader(
          tableName: widget.tableName,
          searchController: _searchController,
          onSearchChanged: _onSearchChanged,
          onClearSearch: _clearSearch,
          hasSearchText: _searchTerm.isNotEmpty,
          onColumnPicker: _showColumnPicker,
          visibleColumnsCount: visibleColumns.length,
          totalColumnsCount: _columns.length,
          onExport: _exportToExcel,
          config: widget.config,
          enableDateFilter: widget.enableDateFilter,
          dateFilterValue: _dateFilter,
          onDateFilterChanged: widget.enableDateFilter
              ? (value) {
                  setState(() => _dateFilter = value);
                  widget.onDateFilterChanged?.call(value);
                }
              : null,
        ),
        const SizedBox(height: 6),
        if (tableData.isEmpty)
          widget.emptyState?.call() ?? _buildEmptyState(context)
        else
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.85,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.15),
                        width: 0.5,
                      ),
                    ),
                    child: DataTableWidget<T>(
                      columns: visibleColumns,
                      data: tableData,
                      rowHeight: widget.rowHeight,
                      minWidth: widget.minWidth,
                      onRowTap: widget.onRowTap,
                      activeFilters: _activeFilters,
                      onFilterPressed: _showFilterDialog,
                      enableRowSelection: widget.enableRowSelection,
                      selectedRows: _selectedRows,
                      onRowSelectionChanged: _toggleRowSelection,
                      onSelectAllChanged: _selectAllRows,
                      activeSortColumnId: _activeSortColumnId,
                      sortAscending: _sortAscending,
                      onSort: _onSortChanged,
                    ),
                  ),
                ),
                if (widget.pagination != null &&
                    widget.pagination!.totalPages != null)
                  TablePaginationFooter(
                    currentPage: widget.pagination?.page ?? 1,
                    totalPages: widget.pagination?.totalPages ?? 1,
                    totalItems: widget.pagination?.totalRows ?? 0,
                    rowsPerPage: widget.pagination?.limit ?? 25,
                    onRowsPerPageChanged: widget.onPageChanged != null
                        ? (newLimit) => widget.onPageChanged!(1, newLimit)
                        : (_) {},
                    onPrevious: widget.onPageChanged != null &&
                            (widget.pagination?.page ?? 1) > 1
                        ? () => widget.onPageChanged!(
                              (widget.pagination?.page ?? 1) - 1,
                              widget.pagination?.limit ?? 25,
                            )
                        : () {},
                    onNext: widget.onPageChanged != null &&
                            (widget.pagination?.page ?? 1) <
                                (widget.pagination?.totalPages ?? 1)
                        ? () => widget.onPageChanged!(
                              (widget.pagination?.page ?? 1) + 1,
                              widget.pagination?.limit ?? 25,
                            )
                        : () {},
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          "No data available",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
