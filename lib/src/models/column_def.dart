import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

/// Defines a dynamic column for the analytics table
class ColumnDef<T> {
  final String id;
  final String label;
  final DataCell Function(T item) cellBuilder;
  final ColumnSize size;
  final double? minWidth;
  final double? fixedWidth;
  final String? tooltip;
  bool visible;
  void Function(int, bool)? onSort;
  final bool filterable;
  final String? Function(T item)? filterValueBuilder;
  final Widget Function(List<T> items)? totalCellBuilder;

  // New properties for better extensibility
  final bool sortable;
  final bool exportable;
  final String? Function(T item)? exportValueBuilder;
  final bool resizable;
  final int? flexFactor;

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
