import 'package:flutter/material.dart';
import '../models/column_def.dart';

/// A dialog that toggles the visibility of each [ColumnDef] in the table.
class ColumnPickerDialog<T> extends StatelessWidget {
  /// The columns whose visibility can be toggled.
  final List<ColumnDef<T>> columns;

  /// Called when the user applies the visibility changes.
  final VoidCallback onApply;

  /// Creates a column picker dialog.
  const ColumnPickerDialog({
    super.key,
    required this.columns,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (ctx, setDialogState) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.view_column,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Configure Columns', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: SizedBox(
            width: 300,
            child: ListView(
              shrinkWrap: true,
              children: columns.map((col) {
                return CheckboxListTile(
                  dense: true,
                  title: Text(col.label, style: const TextStyle(fontSize: 13)),
                  value: col.visible,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (val) =>
                      setDialogState(() => col.visible = val ?? true),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => setDialogState(() {
                for (final col in columns) {
                  col.visible = true;
                }
              }),
              child: const Text('Show All'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                onApply();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
