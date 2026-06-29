/// Tracks which rows are currently selected in the table.
class RowSelectionState<T> {
  /// Indices of the currently selected rows.
  final Set<int> selectedIndices;

  /// Whether every row is currently selected.
  bool isAllSelected;

  /// Creates a selection state, optionally seeded with [selectedIndices].
  RowSelectionState({
    Set<int>? selectedIndices,
    this.isAllSelected = false,
  }) : selectedIndices = selectedIndices ?? {};

  /// Toggles selection for the row at [index].
  void toggleRow(int index) {
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
      isAllSelected = false;
    } else {
      selectedIndices.add(index);
    }
  }

  /// Selects all [totalRows] rows.
  void selectAll(int totalRows) {
    selectedIndices.clear();
    selectedIndices.addAll(List.generate(totalRows, (i) => i));
    isAllSelected = true;
  }

  /// Clears the current selection.
  void clearSelection() {
    selectedIndices.clear();
    isAllSelected = false;
  }

  /// Returns the selected items from [allItems].
  List<T> getSelectedItems(List<T> allItems) {
    return [
      for (final index in selectedIndices)
        if (index < allItems.length) allItems[index],
    ];
  }

  /// Whether the row at [index] is selected.
  bool isRowSelected(int index) => selectedIndices.contains(index);

  /// Number of selected rows.
  int get selectedCount => selectedIndices.length;

  /// Whether no rows are selected.
  bool get isEmpty => selectedIndices.isEmpty;

  /// Whether at least one row is selected.
  bool get isNotEmpty => selectedIndices.isNotEmpty;

  /// Returns a deep copy of this selection state.
  RowSelectionState<T> copy() {
    return RowSelectionState<T>(
      selectedIndices: Set.from(selectedIndices),
      isAllSelected: isAllSelected,
    );
  }
}
