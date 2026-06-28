import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/column_def.dart';

class FilterDialog<T> extends StatelessWidget {
  final ColumnDef<T> column;
  final List<String> uniqueValues;
  final Set<String> initialSelected;
  final ValueChanged<Set<String>> onApply;

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
