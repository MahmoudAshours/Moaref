import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> assetToFile({required String assetPath}) async {
  Directory directory = await getApplicationDocumentsDirectory();

  final path = join(directory.path, assetPath.split('/')[2]);
  final ByteData data = await rootBundle.load(assetPath);
  final List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  final file = await File(path).writeAsBytes(bytes);
  return file.path;
}
