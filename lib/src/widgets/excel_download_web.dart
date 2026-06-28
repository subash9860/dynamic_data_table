import 'dart:convert';

import 'package:web/web.dart' as web;

Future<void> downloadExcel(List<int> bytes, String fileName) async {
  final content = base64Encode(bytes);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href =
        'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$content'
    ..setAttribute('download', fileName);
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}
