import 'package:flutter/material.dart';
import '../models/column_def.dart';

/// Pure functions for filtering, searching, and data processing.
class TableDataProcessor<T> {
  /// The raw, unfiltered rows.
  final List<T> data;

  /// The column definitions used for searching and filtering.
  final List<ColumnDef<T>> columns;

  /// Builds the searchable string for an [item]; falls back to cell text.
  final String Function(T item)? searchStringBuilder;

  /// The current search query.
  final String searchTerm;

  /// Active column filters, mapping column id to the set of allowed values.
  final Map<String, Set<String>> activeFilters;

  /// If true, [data] is already filtered by search externally (remote search).
  final bool useRemoteSearch;

  /// Creates a processor over [data] with the given search and filter state.
  TableDataProcessor({
    required this.data,
    required this.columns,
    this.searchStringBuilder,
    required this.searchTerm,
    required this.activeFilters,
    required this.useRemoteSearch,
  });

  /// The columns that are currently visible.
  List<ColumnDef<T>> get visibleColumns =>
      columns.where((c) => c.visible).toList();

  /// Whether a non-empty [searchTerm] is active.
  bool get hasSearch => searchTerm.isNotEmpty;

  /// Returns unique filterable values for a given column.
  List<String> getUniqueValues(ColumnDef<T> col) {
    if (col.filterValueBuilder == null) return [];
    final values = data
        .map((e) => col.filterValueBuilder!(e) ?? '')
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    values.sort();
    return values;
  }

  /// Local search matching logic.
  bool matchesSearch(T item, String term) {
    if (term.isEmpty) return true;
    final searchLower = term.toLowerCase();
    if (searchStringBuilder != null) {
      return searchStringBuilder!(item).toLowerCase().contains(searchLower);
    }
    for (final col in visibleColumns) {
      final child = col.cellBuilder(item).child;
      String? text;
      if (child is Text) {
        text = child.data;
      } else if (child is RichText) {
        text = child.text.toPlainText();
      } else {
        continue;
      }
      if (text != null && text.toLowerCase().contains(searchLower)) return true;
    }
    return false;
  }

  /// Applies search and column filters to the raw data.
  List<T> get filteredData {
    // 1. Apply search (local or remote)
    final searchFiltered = useRemoteSearch
        ? data
        : (searchTerm.isEmpty
            ? data
            : data.where((item) => matchesSearch(item, searchTerm)).toList());

    // 2. Apply column filters
    if (activeFilters.isEmpty) return searchFiltered;
    return searchFiltered.where((row) {
      for (final entry in activeFilters.entries) {
        final col = columns.firstWhere((c) => c.id == entry.key);
        final val = col.filterValueBuilder?.call(row);
        if (!entry.value.contains(val)) return false;
      }
      return true;
    }).toList();
  }
}
