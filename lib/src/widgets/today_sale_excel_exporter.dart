import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import '../models/column_def.dart';

import 'excel_download_io.dart'
    if (dart.library.js_interop) 'excel_download_web.dart';

/// Utility class to export table data to Excel using Syncfusion XlsIO
class TodaySaleExcelExporter {
  /// Export data to Excel
  /// [columns] -> visible columns
  /// [data] -> list of DTOs
  static Future<void> export<T>({
    required List<ColumnDef<T>> columns,
    required List<T> data,
    String fileName = "table_data.xlsx",
  }) async {
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    sheet.getRangeByIndex(1, 1).setText('#');
    for (int i = 0; i < columns.length; i++) {
      sheet.getRangeByIndex(1, i + 2).setText(columns[i].label);
    }

    for (int rowIndex = 0; rowIndex < data.length; rowIndex++) {
      final item = data[rowIndex];
      sheet.getRangeByIndex(rowIndex + 2, 1).setNumber(rowIndex + 1);

      for (int colIndex = 0; colIndex < columns.length; colIndex++) {
        final col = columns[colIndex];
        final cellWidget = col.cellBuilder(item).child;

        String cellValue = '';
        if (cellWidget is Text) {
          cellValue = cellWidget.data ?? '';
        }

        sheet.getRangeByIndex(rowIndex + 2, colIndex + 2).setText(cellValue);
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await downloadExcel(bytes, fileName);
  }
}
