import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

const PORT_NAME = 'downloader_send_port';

class DownloadData {
  final String taskId;
  final String path;

  DownloadData(this.taskId, this.path);
}

class CustomDownloader {
  static Future<DownloadData> downloadVideo(String url) async {
    final path = await _getPath();
    final filename = _getRandomFilename();
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: path,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
      fileName: filename,
    );

    return DownloadData(taskId!, "$path/$filename");
  }

  static String _getRandomFilename() {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return "${String.fromCharCodes(Iterable.generate(10, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))))}.mp4";
  }

  static Future<String> _getPath() async {
    var dir = await (Platform.isIOS
        ? getApplicationSupportDirectory()
        : getApplicationDocumentsDirectory());
    return dir.path;
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName(PORT_NAME);
    print("IM HERE SENDING TO PORT");
    if (send != null) {
      send.send([id, status, progress]);
    }
  }
}
