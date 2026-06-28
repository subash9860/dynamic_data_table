import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/date_filter_model.dart';

/// A compact button that shows the active date filter and opens a picker dialog.
class TableDateFilter extends StatelessWidget {
  final DateFilterValue? value;
  final ValueChanged<DateFilterValue?> onChanged;

  const TableDateFilter({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = value != null;

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        side: BorderSide(
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.4),
        ),
        backgroundColor:
            isActive ? theme.colorScheme.primary.withValues(alpha: 0.08) : null,
        foregroundColor:
            isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        visualDensity: VisualDensity.compact,
      ),
      icon: const Icon(Icons.date_range_outlined, size: 16),
      label: Text(
        isActive ? value!.displayLabel : 'Date Filter',
        style: const TextStyle(fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: () => _openDialog(context),
    );
  }

  void _openDialog(BuildContext context) async {
    final result = await showDialog<DateFilterValue?>(
      context: context,
      builder: (_) => _DateFilterDialog(initial: value),
    );
    // result == null means the dialog was dismissed without intent; we use a
    // sentinel _ClearSentinel to distinguish "clear" from "dismiss".
    if (result is _ClearSentinel) {
      onChanged(null);
    } else if (result != null) {
      onChanged(result);
    }
  }
}

// Internal sentinel so we can distinguish "clear" from "dismiss".
class _ClearSentinel extends DateFilterValue {
  const _ClearSentinel() : super(preset: DateFilterPreset.today);
}

/// Full-screen-ish dialog with preset chips on the left and a custom
/// date/range picker on the right (when needed).
class _DateFilterDialog extends StatefulWidget {
  final DateFilterValue? initial;

  const _DateFilterDialog({this.initial});

  @override
  State<_DateFilterDialog> createState() => _DateFilterDialogState();
}

class _DateFilterDialogState extends State<_DateFilterDialog> {
  late DateFilterPreset _selected;
  DateTime? _customDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  static const _presets = [
    DateFilterPreset.today,
    DateFilterPreset.yesterday,
    DateFilterPreset.thisWeek,
    DateFilterPreset.lastWeek,
    DateFilterPreset.thisMonth,
    DateFilterPreset.lastMonth,
    DateFilterPreset.customDate,
    DateFilterPreset.customDateRange,
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _selected = initial.preset;
      _customDate = initial.customDate;
      _rangeStart = initial.rangeStart;
      _rangeEnd = initial.rangeEnd;
    } else {
      _selected = DateFilterPreset.today;
    }
  }

  bool get _canApply {
    if (_selected == DateFilterPreset.customDate) return _customDate != null;
    if (_selected == DateFilterPreset.customDateRange) {
      return _rangeStart != null && _rangeEnd != null;
    }
    return true;
  }

  DateFilterValue get _buildValue => DateFilterValue(
        preset: _selected,
        customDate: _customDate,
        rangeStart: _rangeStart,
        rangeEnd: _rangeEnd,
      );

  void _apply() => Navigator.of(context).pop(_buildValue);
  void _clear() => Navigator.of(context).pop(const _ClearSentinel());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                children: [
                  Icon(
                    Icons.date_range_outlined,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filter by Date',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // ── Preset chips ──
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _presets.map((p) {
                  final active = _selected == p;
                  return ChoiceChip(
                    label: Text(p.label, style: const TextStyle(fontSize: 12)),
                    selected: active,
                    onSelected: (_) => setState(() => _selected = p),
                    selectedColor: theme.colorScheme.primary.withValues(
                      alpha: 0.15,
                    ),
                    labelStyle: TextStyle(
                      color: active
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: active
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    showCheckmark: false,
                  );
                }).toList(),
              ),

              // ── Custom date / range pickers ──
              if (_selected == DateFilterPreset.customDate) ...[
                const SizedBox(height: 20),
                Text(
                  'Select Date',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _DatePickerTile(
                  label: 'Date',
                  value: _customDate,
                  onPicked: (d) => setState(() => _customDate = d),
                ),
              ],
              if (_selected == DateFilterPreset.customDateRange) ...[
                const SizedBox(height: 20),
                Text(
                  'Select Date Range',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _DatePickerTile(
                        label: 'From',
                        value: _rangeStart,
                        lastDate: _rangeEnd,
                        onPicked: (d) => setState(() {
                          _rangeStart = d;
                          // ensure end is not before start
                          if (_rangeEnd != null && _rangeEnd!.isBefore(d)) {
                            _rangeEnd = d;
                          }
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DatePickerTile(
                        label: 'To',
                        value: _rangeEnd,
                        firstDate: _rangeStart,
                        onPicked: (d) => setState(() => _rangeEnd = d),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // ── Actions ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.initial != null)
                    TextButton.icon(
                      onPressed: _clear,
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _canApply ? _apply : null,
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A tappable tile that opens a [showDatePicker] and displays the result.
class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onPicked;

  const _DatePickerTile({
    required this.label,
    required this.onPicked,
    this.value,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = DateFormat('dd MMM yyyy');
    final hasValue = value != null;

    return InkWell(
      onTap: () => _pick(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasValue
                ? theme.colorScheme.primary.withValues(alpha: 0.6)
                : theme.colorScheme.outline.withValues(alpha: 0.35),
            width: hasValue ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: hasValue
              ? theme.colorScheme.primary.withValues(alpha: 0.04)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: hasValue
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.55,
                      ),
                    ),
                  ),
                  Text(
                    hasValue ? fmt.format(value!) : 'Select…',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: hasValue
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withValues(alpha: 0.45),
                      fontWeight:
                          hasValue ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: firstDate ?? DateTime(now.year - 10),
      lastDate: lastDate ?? DateTime(now.year + 1),
    );
    if (picked != null) onPicked(picked);
  }
}
