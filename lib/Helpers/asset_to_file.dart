import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

assetToFile({String assetPath}) async {
  Directory directory = await getApplicationDocumentsDirectory();

  var soundPath = join(directory.path, assetPath.split('/')[2]);
  ByteData soundData = await rootBundle.load(assetPath);
  List<int> soundBytes = soundData.buffer
      .asUint8List(soundData.offsetInBytes, soundData.lengthInBytes);
  var file = await File(soundPath).writeAsBytes(soundBytes);
  return file.path;
}
