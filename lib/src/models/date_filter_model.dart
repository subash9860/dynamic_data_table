import 'package:intl/intl.dart';

enum DateFilterPreset {
  today,
  yesterday,
  thisWeek,
  lastWeek,
  thisMonth,
  lastMonth,
  customDate,
  customDateRange,
}

extension DateFilterPresetLabel on DateFilterPreset {
  String get label {
    switch (this) {
      case DateFilterPreset.today:
        return 'Today';
      case DateFilterPreset.yesterday:
        return 'Yesterday';
      case DateFilterPreset.thisWeek:
        return 'This Week';
      case DateFilterPreset.lastWeek:
        return 'Last Week';
      case DateFilterPreset.thisMonth:
        return 'This Month';
      case DateFilterPreset.lastMonth:
        return 'Last Month';
      case DateFilterPreset.customDate:
        return 'Custom Date';
      case DateFilterPreset.customDateRange:
        return 'Custom Range';
    }
  }
}

class DateFilterValue {
  final DateFilterPreset preset;

  /// Only set when [preset] is [DateFilterPreset.customDate].
  final DateTime? customDate;

  /// Only set when [preset] is [DateFilterPreset.customDateRange].
  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  const DateFilterValue({
    required this.preset,
    this.customDate,
    this.rangeStart,
    this.rangeEnd,
  });

  /// Inclusive start of the filter range (start of day).
  DateTime get startDate {
    final now = DateTime.now();
    switch (preset) {
      case DateFilterPreset.today:
        return _startOfDay(now);
      case DateFilterPreset.yesterday:
        return _startOfDay(now.subtract(const Duration(days: 1)));
      case DateFilterPreset.thisWeek:
        final weekday = now.weekday; // Mon=1 … Sun=7
        return _startOfDay(now.subtract(Duration(days: weekday - 1)));
      case DateFilterPreset.lastWeek:
        final weekday = now.weekday;
        final startOfThisWeek =
            now.subtract(Duration(days: weekday - 1));
        return _startOfDay(startOfThisWeek.subtract(const Duration(days: 7)));
      case DateFilterPreset.thisMonth:
        return DateTime(now.year, now.month, 1);
      case DateFilterPreset.lastMonth:
        final first = DateTime(now.year, now.month, 1);
        return DateTime(first.year, first.month - 1, 1);
      case DateFilterPreset.customDate:
        return _startOfDay(customDate ?? now);
      case DateFilterPreset.customDateRange:
        return _startOfDay(rangeStart ?? now);
    }
  }

  /// Inclusive end of the filter range (end of day).
  DateTime get endDate {
    final now = DateTime.now();
    switch (preset) {
      case DateFilterPreset.today:
        return _endOfDay(now);
      case DateFilterPreset.yesterday:
        return _endOfDay(now.subtract(const Duration(days: 1)));
      case DateFilterPreset.thisWeek:
        final weekday = now.weekday;
        return _endOfDay(now.add(Duration(days: 7 - weekday)));
      case DateFilterPreset.lastWeek:
        final weekday = now.weekday;
        final startOfThisWeek =
            now.subtract(Duration(days: weekday - 1));
        final endOfLastWeek =
            startOfThisWeek.subtract(const Duration(days: 1));
        return _endOfDay(endOfLastWeek);
      case DateFilterPreset.thisMonth:
        return _endOfDay(DateTime(now.year, now.month + 1, 0));
      case DateFilterPreset.lastMonth:
        final first = DateTime(now.year, now.month, 1);
        return _endOfDay(DateTime(first.year, first.month, 0));
      case DateFilterPreset.customDate:
        return _endOfDay(customDate ?? now);
      case DateFilterPreset.customDateRange:
        return _endOfDay(rangeEnd ?? rangeStart ?? now);
    }
  }

  /// Human-readable label for the active filter chip / button.
  String get displayLabel {
    final fmt = DateFormat('dd MMM yyyy');
    switch (preset) {
      case DateFilterPreset.customDate:
        return customDate != null ? fmt.format(customDate!) : 'Custom Date';
      case DateFilterPreset.customDateRange:
        if (rangeStart != null && rangeEnd != null) {
          return '${fmt.format(rangeStart!)} – ${fmt.format(rangeEnd!)}';
        }
        return 'Custom Range';
      default:
        return preset.label;
    }
  }

  DateFilterValue copyWith({
    DateFilterPreset? preset,
    DateTime? customDate,
    DateTime? rangeStart,
    DateTime? rangeEnd,
  }) =>
      DateFilterValue(
        preset: preset ?? this.preset,
        customDate: customDate ?? this.customDate,
        rangeStart: rangeStart ?? this.rangeStart,
        rangeEnd: rangeEnd ?? this.rangeEnd,
      );

  static DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
  static DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);
}
