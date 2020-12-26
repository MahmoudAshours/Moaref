import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

assetToFile({String assetPath}) async {
  Directory directory = await getApplicationDocumentsDirectory();

  var path = join(directory.path, assetPath.split('/')[2]);
  ByteData data = await rootBundle.load(assetPath);
  List<int> bytes = data.buffer
      .asUint8List(data.offsetInBytes, data.lengthInBytes);
  var file = await File(path).writeAsBytes(bytes);
  return file.path;
}
