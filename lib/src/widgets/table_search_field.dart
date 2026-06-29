import 'package:flutter/material.dart';

/// A styled search text field with a clear button used in the table header.
class TableSearchField extends StatelessWidget {
  /// Controller for the underlying text field.
  final TextEditingController controller;

  /// Called when the text changes.
  final void Function(String) onChanged;

  /// Called when the clear button is pressed.
  final VoidCallback onClear;

  /// Whether the field currently has text (controls the clear button).
  final bool hasText;

  /// Fixed width in logical pixels; when `null` the field expands to fit.
  final double? width;

  /// Placeholder text shown when the field is empty.
  final String hintText;

  /// Creates a search field.
  const TableSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.hasText,
    this.width = 250,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outline.withValues(alpha: 0.25);
    final field = TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
        ),
        prefixIcon: Icon(
          Icons.search,
          size: 20,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
        ),
        suffixIcon: hasText
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.35),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        isDense: true,
      ),
    );
    if (width == null) return field;
    return SizedBox(width: width, child: field);
  }
}
