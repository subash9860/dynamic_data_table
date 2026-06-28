import 'package:flutter/material.dart';

class SortIndicator extends StatelessWidget {
  final String columnId;
  final String? activeSortColumnId;
  final bool sortAscending;
  final VoidCallback onSort;

  const SortIndicator({
    super.key,
    required this.columnId,
    required this.activeSortColumnId,
    required this.sortAscending,
    required this.onSort,
  });

  bool get isActive => activeSortColumnId == columnId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive ? theme.colorScheme.primary : Colors.grey.withValues(alpha: 0.4);

    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: Tooltip(
          message: isActive
              ? (sortAscending ? 'Sorted ascending' : 'Sorted descending')
              : 'Click to sort',
          child: GestureDetector(
            onTap: onSort,
            child: Icon(
              isActive
                  ? (sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                  : Icons.unfold_more,
              size: 16,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
