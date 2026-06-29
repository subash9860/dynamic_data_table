/// Configuration for a [DynamicDataTable]: UI labels, accessibility strings
/// and feature toggles.
///
/// Pass an instance to customize the table's text and enable optional
/// features such as row selection or advanced filtering.
class TableConfig {
  /// Text shown when the table has no rows to display.
  final String? emptyStateText;

  /// Placeholder text for the search field.
  final String searchHint;

  /// Label for the filter control.
  final String filterLabel;

  /// Label for the export control.
  final String exportLabel;

  /// Label for the "select all rows" control.
  final String selectAllLabel;

  /// Label for the confirm/apply action in dialogs.
  final String applyLabel;

  /// Label for the cancel action in dialogs.
  final String cancelLabel;

  /// Accessibility label announced for the table as a whole.
  final String? tableAriaLabel;

  /// Accessibility label announced for the row-selection controls.
  final String? rowSelectionAriaLabel;

  /// Returns whether exporting is currently allowed; defaults to allowed.
  final bool Function()? canExport;

  /// Base file name used for exported files (without extension).
  final String? exportFileName;

  /// Whether per-row selection checkboxes are enabled.
  final bool enableRowSelection;

  /// Whether the table renders a loading state.
  final bool enableLoadingState;

  /// Whether sort direction indicators are shown in headers.
  final bool enableSortIndicators;

  /// Whether keyboard navigation is enabled.
  final bool enableKeyboardNavigation;

  /// Whether per-column advanced filtering is enabled.
  final bool enableAdvancedFiltering;

  /// Creates a table configuration with optional overrides for labels and
  /// feature toggles.
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

  /// Returns a copy of this config with the given fields replaced.
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
