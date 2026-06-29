import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/column_def.dart';

/// A dialog that lets the user pick which values to keep for a single
/// filterable [column].
class FilterDialog<T> extends StatelessWidget {
  /// The column being filtered.
  final ColumnDef<T> column;

  /// All distinct values available for the column.
  final List<String> uniqueValues;

  /// The values currently selected when the dialog opens.
  final Set<String> initialSelected;

  /// Called with the chosen values when the user applies the filter.
  final ValueChanged<Set<String>> onApply;

  /// Creates a filter dialog for [column].
  const FilterDialog({
    super.key,
    required this.column,
    required this.uniqueValues,
    required this.initialSelected,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (ctx, setDialogState) {
        return AlertDialog(
          title: Text("Filter ${column.label}"),
          content: SizedBox(
            width: 300,
            child: ListView(
              shrinkWrap: true,
              children: [
                CheckboxListTile(
                  title: const Text("Select All"),
                  value: initialSelected.length == uniqueValues.length,
                  onChanged: (v) => setDialogState(() {
                    log("Select All changed: $v");
                    if (v == true) {
                      initialSelected
                        ..clear()
                        ..addAll(uniqueValues);
                    } else {
                      initialSelected.clear();
                    }
                  }),
                ),
                const Divider(),
                ...uniqueValues.map(
                  (v) => CheckboxListTile(
                    dense: true,
                    title: Text(v),
                    value: initialSelected.contains(v),
                    onChanged: (checked) => setDialogState(() {
                      if (checked == true) {
                        initialSelected.add(v);
                      } else {
                        initialSelected.remove(v);
                      }
                    }),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                onApply(initialSelected);
              },
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }
}
