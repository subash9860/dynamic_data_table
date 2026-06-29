import 'package:intl/intl.dart';

/// Predefined date ranges (plus custom options) used by the table's date
/// filter.
enum DateFilterPreset {
  /// The current day.
  today,

  /// The previous day.
  yesterday,

  /// The current calendar week (Monday–Sunday).
  thisWeek,

  /// The previous calendar week.
  lastWeek,

  /// The current calendar month.
  thisMonth,

  /// The previous calendar month.
  lastMonth,

  /// A single user-picked date.
  customDate,

  /// A user-picked start/end date range.
  customDateRange,
}

/// Provides a human-readable [label] for each [DateFilterPreset].
extension DateFilterPresetLabel on DateFilterPreset {
  /// Display label for the preset, e.g. "This Week".
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

/// An active date filter selection: a [preset] plus any custom dates it needs.
class DateFilterValue {
  /// The selected preset that determines the effective range.
  final DateFilterPreset preset;

  /// Only set when [preset] is [DateFilterPreset.customDate].
  final DateTime? customDate;

  /// Range start; only set when [preset] is
  /// [DateFilterPreset.customDateRange].
  final DateTime? rangeStart;

  /// Range end; only set when [preset] is [DateFilterPreset.customDateRange].
  final DateTime? rangeEnd;

  /// Creates a date filter value for the given [preset].
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
        final startOfThisWeek = now.subtract(Duration(days: weekday - 1));
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
        final startOfThisWeek = now.subtract(Duration(days: weekday - 1));
        final endOfLastWeek = startOfThisWeek.subtract(const Duration(days: 1));
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

  /// Returns a copy of this value with the given fields replaced.
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
