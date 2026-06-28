class TableConfig {
  final String? emptyStateText;
  final String searchHint;
  final String filterLabel;
  final String exportLabel;
  final String selectAllLabel;
  final String applyLabel;
  final String cancelLabel;
  final String? tableAriaLabel;
  final String? rowSelectionAriaLabel;

  final bool Function()? canExport;
  final String? exportFileName;

  final bool enableRowSelection;
  final bool enableLoadingState;
  final bool enableSortIndicators;
  final bool enableKeyboardNavigation;
  final bool enableAdvancedFiltering;

  TableConfig({
    this.emptyStateText,
    this.searchHint = 'Search...',
    this.filterLabel = 'Filter',
    this.exportLabel = 'Export',
    this.selectAllLabel = 'Select All',
    this.applyLabel = 'Apply',
    this.cancelLabel = 'Cancel',
    this.tableAriaLabel,
    this.rowSelectionAriaLabel,
    this.canExport,
    this.exportFileName,
    this.enableRowSelection = false,
    this.enableLoadingState = true,
    this.enableSortIndicators = true,
    this.enableKeyboardNavigation = true,
    this.enableAdvancedFiltering = false,
  });

  TableConfig copyWith({
    String? emptyStateText,
    String? searchHint,
    String? filterLabel,
    String? exportLabel,
    String? selectAllLabel,
    String? applyLabel,
    String? cancelLabel,
    String? tableAriaLabel,
    String? rowSelectionAriaLabel,
    bool Function()? canExport,
    String? exportFileName,
    bool? enableRowSelection,
    bool? enableLoadingState,
    bool? enableSortIndicators,
    bool? enableKeyboardNavigation,
    bool? enableAdvancedFiltering,
  }) {
    return TableConfig(
      emptyStateText: emptyStateText ?? this.emptyStateText,
      searchHint: searchHint ?? this.searchHint,
      filterLabel: filterLabel ?? this.filterLabel,
      exportLabel: exportLabel ?? this.exportLabel,
      selectAllLabel: selectAllLabel ?? this.selectAllLabel,
      applyLabel: applyLabel ?? this.applyLabel,
      cancelLabel: cancelLabel ?? this.cancelLabel,
      tableAriaLabel: tableAriaLabel ?? this.tableAriaLabel,
      rowSelectionAriaLabel:
          rowSelectionAriaLabel ?? this.rowSelectionAriaLabel,
      canExport: canExport ?? this.canExport,
      exportFileName: exportFileName ?? this.exportFileName,
      enableRowSelection: enableRowSelection ?? this.enableRowSelection,
      enableLoadingState: enableLoadingState ?? this.enableLoadingState,
      enableSortIndicators: enableSortIndicators ?? this.enableSortIndicators,
      enableKeyboardNavigation:
          enableKeyboardNavigation ?? this.enableKeyboardNavigation,
      enableAdvancedFiltering:
          enableAdvancedFiltering ?? this.enableAdvancedFiltering,
    );
  }
}
