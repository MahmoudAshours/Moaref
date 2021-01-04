import 'dart:io';

import 'package:ffmpegtest/Helpers/random_string.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordProvider extends ChangeNotifier {
  var path;
  var sounds = [];

  Future<void> recordSound() async {
    await Record.hasPermission();
    Directory directory = await getTemporaryDirectory();
    path = join(directory.path, '${getRandString(10)}');
    await Record.start(
      path: '$path', // required
      encoder: AudioEncoder.AAC, // by default
    );
  }

  void endRecord() {
    Record.stop().then((value) {
      sounds.add(path);
      notifyListeners();
    });
  }
}
