import 'package:flutter/material.dart';

/// A tappable header icon showing whether a column is sorted and in which
/// direction.
class SortIndicator extends StatelessWidget {
  /// Id of the column this indicator belongs to.
  final String columnId;

  /// Id of the column currently being sorted, if any.
  final String? activeSortColumnId;

  /// Whether the active sort is ascending.
  final bool sortAscending;

  /// Called when the indicator is tapped to change the sort.
  final VoidCallback onSort;

  /// Creates a sort indicator for [columnId].
  const SortIndicator({
    super.key,
    required this.columnId,
    required this.activeSortColumnId,
    required this.sortAscending,
    required this.onSort,
  });

  /// Whether this column is the one currently being sorted.
  bool get isActive => activeSortColumnId == columnId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? theme.colorScheme.primary
        : Colors.grey.withValues(alpha: 0.4);

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
