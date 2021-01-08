import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ffmpegtest/Helpers/link_manipulation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;

class GalleryProvider extends ChangeNotifier {
  String url;
  StreamController<List<String>> galleryLinks = StreamController.broadcast();

  List wallPapers = [];
  // ignore: must_call_super
  void dispose() {
    galleryLinks.close();
  }

  Future getGalleryImages() async {
    url = "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/";
    var response = await Dio().get(url);
    var document = parser.parse(response.data);
    var links = languageManipulator(document);
    if (links != null) galleryLinks.sink.add(links);
    print(links);
  }

  Future uploadFile(context) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      File file = File(result.files.single.path);
      wallPapers.add(file.path);
      Navigator.of(context).pop();
      notifyListeners();
    } else {
      Navigator.of(context).pop();
    }
  }
}
