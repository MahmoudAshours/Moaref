import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:konmoaref/Helpers/link_manipulation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:konmoaref/Utils/connectivity_issues.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class GalleryProvider extends ChangeNotifier {
  late String url;
  StreamController<List<String>> galleryLinks = StreamController.broadcast();
  String videoPath = "";
  List<String> customWallpapers = [];
  late Map downloadInfo = {};
  // ignore: must_call_super
  void dispose() => galleryLinks.close();

  static Future<Response> dioDownloadVideo(List<String> downloadData) async {
    return await Dio().download(downloadData[0], downloadData[1]);
  }

  static Future<Response> dioDownloadVideoTablet(
      List<String> downloadData) async {
    return await Dio().download(downloadData[0], downloadData[1]);
  }

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
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ConnectivityIssues.noInternet();
    } else {
      try {
        url = "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/";
        var response = await Dio().get(url);
        var document = parser.parse(response.data);
        var links = ApiDecoder.languageDecoder(document);
        galleryLinks.sink.add(links);
      } catch (e) {}
    }
  }

  Future downloadFile(String url) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ConnectivityIssues.noInternet();
    } else {
      final newUrl = url.replaceAll('jpg', 'mp4');
      final videoUrl =
          "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/$newUrl";
      final _dir = await getApplicationDocumentsDirectory();
      final _dirPath = _dir.path;
      try {
        await Dio().download(videoUrl, "$_dirPath/$newUrl");
        final _ytUrl = videoUrl.replaceFirst('mobile', 'youtube');
        final _ytPath = "$_dirPath/${newUrl.replaceFirst('mobile', 'youtube')}";
        await Dio().download(_ytUrl, _ytPath);
        print(_ytPath);
      } catch (e) {
        print(e);
      }
      notifyListeners();
      downloadInfo.clear();
      return true;
    }
  }

  Future uploadVideoFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      dialogTitle: 'اختر مقطعا مناسب',
    );

    if (result != null) {
      try {
        File file = File(result.files.first.path);
        customWallpapers.add(file.path);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }
}
