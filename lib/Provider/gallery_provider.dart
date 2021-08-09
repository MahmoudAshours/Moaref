import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ffmpegtest/Helpers/link_manipulation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:path_provider/path_provider.dart';

class GalleryProvider extends ChangeNotifier {
  late String url;
  StreamController<List<String>> galleryLinks = StreamController.broadcast();
  String videoPath = "";
  List customWallpapers = [];
  late var downloadInfo = {};
  // ignore: must_call_super
  void dispose() => galleryLinks.close();

  Future setVideoPath(path) async {
    String? fileName = path.replaceAll('jpg', 'mp4');
    String dir = (await getApplicationDocumentsDirectory()).path;
    videoPath = '$dir/$fileName';
    notifyListeners();
  }

  Future<bool> checkIfVideoExists(String url) async {
    String fileName = url.replaceAll('jpg', 'mp4');
    String dir = (await getApplicationDocumentsDirectory()).path;
    String savePath = '$dir/$fileName';
    return File('$savePath').exists();
  }

  Future getGalleryImages() async {
    try {
      url = "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/";
      var response = await Dio().get(url);
      var document = parser.parse(response.data);
      var links = languageManipulator(document);
      galleryLinks.sink.add(links);
    } catch (e) {}
  }

  Future downloadFile(String url) async {
    Dio dio = Dio();
    var newUrl = url.replaceAll('jpg', 'mp4');
    var videoUrl =
        "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/$newUrl";
    try {
      var dir = (await getApplicationDocumentsDirectory()).path;
      await dio.download(
        videoUrl,
        "$dir/$newUrl",
        onReceiveProgress: (rec, total) {
          downloadInfo = {'rec': rec, 'total': total};
          notifyListeners();
          print("Rec: $rec , Total: $total");
        },
      );
      downloadInfo.clear();
    } catch (e) {
      print(e);
    }
    return true;
  }

  Future uploadFile(context) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      File file = File(result.files.single.path!);
      customWallpapers.add(file.path);
      Navigator.of(context).pop();
      notifyListeners();
    } else {
      Navigator.of(context).pop();
    }
  }
}
