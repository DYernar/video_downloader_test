import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_downloader/model/video_data.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static saveVideos(List<VideoData> videos) async {
    List<String> videosJson =
        videos.map((video) => json.encode(video.toJson())).toList();
    await prefs.setStringList('videos', videosJson);
  }

  static removeVideos() async {
    await prefs.remove("videos");
  }

  static getVideos() async {
    List<String>? videosJson = await prefs.getStringList('videos');
    if (videosJson == null) {
      List<VideoData> res = [];
      return res;
    }
    return videosJson
        .map((videoJson) => VideoData.fromJson(json.decode(videoJson)))
        .toList();
  }
}
