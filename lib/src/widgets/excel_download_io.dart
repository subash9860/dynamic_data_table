import 'dart:io' as io;

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadExcel(List<int> bytes, String fileName) async {
  final dir = await getTemporaryDirectory();
  final file = io.File('${dir.path}/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  await OpenFile.open(file.path);
}
