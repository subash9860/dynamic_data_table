import 'column_def.dart';

abstract class TableExporter {
  String get format; // 'excel', 'csv', 'pdf'
  String get mimeType;

  Future<List<int>> export<T>({
    required List<ColumnDef<T>> columns,
    required List<T> data,
  });

  String sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
  }
}

class ExportConfig {
  final Map<String, TableExporter> exporters;
  final String defaultFormat;

  const ExportConfig({
    required this.exporters,
    this.defaultFormat = 'excel',
  });

  TableExporter? getExporter(String format) => exporters[format];

  List<String> get availableFormats => exporters.keys.toList();
}
