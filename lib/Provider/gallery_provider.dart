import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:konmoaref/Helpers/link_manipulation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryProvider extends ChangeNotifier {
  late String url;
  StreamController<List<String>> galleryLinks = StreamController.broadcast();
  String? videoPath = "";
  List<String> customWallpapers = [];
  late Map downloadInfo = {};
  // ignore: must_call_super
  void dispose() => galleryLinks.close();

  Future setVideoPath(String path, {bool isUploaded = false}) async {
    if (!isUploaded) {
      String? fileName = path.replaceAll('jpg', 'mp4');
      String dir = (await getApplicationDocumentsDirectory()).path;
      videoPath = '$dir/$fileName';
      notifyListeners();
    } else {
      videoPath = path;
      notifyListeners();
    }
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
      var links = languageDecoder(document);
      galleryLinks.sink.add(links);
    } catch (e) {}
  }

  Future downloadFile(String url) async {
    final newUrl = url.replaceAll('jpg', 'mp4');
    final videoUrl =
        "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/$newUrl";
    try {
      final _dir = (await getApplicationDocumentsDirectory()).path;
      await compute(_dioDownloadVideo, [videoUrl, "$_dir/$newUrl"]);
      notifyListeners();
      downloadInfo.clear();
    } catch (e) {
      print(e);
    }
    return true;
  }

  Future uploadVideoFile(BuildContext context) async {
    Permission.accessMediaLocation.request();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      dialogTitle: 'اختر مقطعا مناسب',
    );

    if (result != null) {
      try {
        File file = File(result.files.first.path!);
        customWallpapers.add(file.path);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }
}

_dioDownloadVideo(List<String> downloadData) async =>
    await Dio().download(downloadData[0], downloadData[1]);
