import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:ffmpegtest/Helpers/link_manipulation.dart';
import 'package:ffmpegtest/Models/sound_state.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as parser;

class GalleryProvider extends ChangeNotifier {
  String url;
  StreamController<List<String>> galleryLinks = StreamController.broadcast();

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
}
