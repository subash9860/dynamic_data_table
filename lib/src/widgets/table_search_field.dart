import 'package:flutter/material.dart';

class TableSearchField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  final VoidCallback onClear;
  final bool hasText;
  final double? width;
  final String hintText;

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
    final field = TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search, size: 18),
        suffixIcon: hasText
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: onClear,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        isDense: true,
      ),
    );
    if (width == null) return field;
    return SizedBox(width: width, child: field);
  }
}
