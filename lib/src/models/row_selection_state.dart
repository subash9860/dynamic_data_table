class RowSelectionState<T> {
  final Set<int> selectedIndices;
  bool isAllSelected;

  RowSelectionState({
    Set<int>? selectedIndices,
    this.isAllSelected = false,
  }) : selectedIndices = selectedIndices ?? {};

  void toggleRow(int index) {
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
      isAllSelected = false;
    } else {
      selectedIndices.add(index);
    }
  }

  void selectAll(int totalRows) {
    selectedIndices.clear();
    selectedIndices.addAll(List.generate(totalRows, (i) => i));
    isAllSelected = true;
  }

  void clearSelection() {
    selectedIndices.clear();
    isAllSelected = false;
  }

  List<T> getSelectedItems(List<T> allItems) {
    return [
      for (final index in selectedIndices)
        if (index < allItems.length) allItems[index],
    ];
  }

  bool isRowSelected(int index) => selectedIndices.contains(index);

  int get selectedCount => selectedIndices.length;

  bool get isEmpty => selectedIndices.isEmpty;

  bool get isNotEmpty => selectedIndices.isNotEmpty;

  RowSelectionState<T> copy() {
    return RowSelectionState<T>(
      selectedIndices: Set.from(selectedIndices),
      isAllSelected: isAllSelected,
    );
  }
}
