import 'column_def.dart';

/// Strategy for exporting table data into a specific file format.
///
/// Implement this to support a format such as Excel, CSV or PDF and register
/// it in an [ExportConfig].
abstract class TableExporter {
  /// Short format identifier, e.g. `'excel'`, `'csv'` or `'pdf'`.
  String get format;

  /// MIME type of the produced file.
  String get mimeType;

  /// Encodes [data] for the given [columns] into the format's raw bytes.
  Future<List<int>> export<T>({
    required List<ColumnDef<T>> columns,
    required List<T> data,
  });

  /// Replaces characters unsafe for file names in [name] with underscores.
  String sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
  }
}

/// Registry of available [TableExporter]s and the default export format.
class ExportConfig {
  /// Available exporters keyed by their [TableExporter.format].
  final Map<String, TableExporter> exporters;

  /// Format used when none is explicitly chosen.
  final String defaultFormat;

  /// Creates an export configuration from a map of [exporters].
  const ExportConfig({
    required this.exporters,
    this.defaultFormat = 'excel',
  });

  /// Returns the exporter registered for [format], or `null` if none.
  TableExporter? getExporter(String format) => exporters[format];

  /// The list of registered format identifiers.
  List<String> get availableFormats => exporters.keys.toList();
}
