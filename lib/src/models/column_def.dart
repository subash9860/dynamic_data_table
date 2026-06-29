import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

/// Defines a single column for a dynamic data table.
///
/// A [ColumnDef] describes how a column renders, sorts, filters and exports
/// values for items of type [T]. Pass a list of these to the table widget to
/// configure its columns.
class ColumnDef<T> {
  /// Stable, unique identifier for the column (used for sorting/state).
  final String id;

  /// Human-readable header text shown for the column.
  final String label;

  /// Builds the [DataCell] for a given row [item].
  final DataCell Function(T item) cellBuilder;

  /// Relative sizing hint for the column.
  final ColumnSize size;

  /// Minimum width in logical pixels the column may shrink to.
  final double? minWidth;

  /// Fixed width in logical pixels; overrides [size] when set.
  final double? fixedWidth;

  /// Optional tooltip shown on the column header; defaults to [label].
  final String? tooltip;

  /// Whether the column is currently visible.
  bool visible;

  /// Callback invoked when the column is sorted, with the column index and
  /// ascending flag.
  void Function(int, bool)? onSort;

  /// Whether the column participates in filtering.
  final bool filterable;

  /// Extracts the string value used when filtering a row [item].
  final String? Function(T item)? filterValueBuilder;

  /// Builds an aggregate/total cell for the column from all [items].
  final Widget Function(List<T> items)? totalCellBuilder;

  /// Whether the column can be sorted.
  final bool sortable;

  /// Whether the column is included when exporting.
  final bool exportable;

  /// Extracts the string value used when exporting a row [item].
  final String? Function(T item)? exportValueBuilder;

  /// Whether the user can resize the column.
  final bool resizable;

  /// Flex factor used to distribute remaining width among flexible columns.
  final int? flexFactor;

  /// Creates a column definition.
  ColumnDef({
    required this.id,
    required this.label,
    required this.cellBuilder,
    this.size = ColumnSize.M,
    this.visible = true,
    this.filterable = false,
    this.filterValueBuilder,
    this.minWidth,
    this.fixedWidth,
    this.tooltip,
    this.onSort,
    this.totalCellBuilder,
    this.sortable = true,
    this.exportable = true,
    this.exportValueBuilder,
    this.resizable = true,
    this.flexFactor,
  });

  /// Returns a copy of this column with the given fields replaced.
  ColumnDef<T> copyWith({
    String? id,
    String? label,
    DataCell Function(T)? cellBuilder,
    ColumnSize? size,
    double? minWidth,
    double? fixedWidth,
    String? tooltip,
    void Function(int, bool)? onSort,
    bool? filterable,
    String? Function(T)? filterValueBuilder,
    Widget Function(List<T>)? totalCellBuilder,
    bool? visible,
    bool? sortable,
    bool? exportable,
    String? Function(T)? exportValueBuilder,
    bool? resizable,
    int? flexFactor,
  }) {
    return ColumnDef<T>(
      id: id ?? this.id,
      label: label ?? this.label,
      cellBuilder: cellBuilder ?? this.cellBuilder,
      size: size ?? this.size,
      minWidth: minWidth ?? this.minWidth,
      fixedWidth: fixedWidth ?? this.fixedWidth,
      tooltip: tooltip ?? this.tooltip,
      onSort: onSort ?? this.onSort,
      filterable: filterable ?? this.filterable,
      filterValueBuilder: filterValueBuilder ?? this.filterValueBuilder,
      totalCellBuilder: totalCellBuilder ?? this.totalCellBuilder,
      visible: visible ?? this.visible,
      sortable: sortable ?? this.sortable,
      exportable: exportable ?? this.exportable,
      exportValueBuilder: exportValueBuilder ?? this.exportValueBuilder,
      resizable: resizable ?? this.resizable,
      flexFactor: flexFactor ?? this.flexFactor,
    );
  }
}
