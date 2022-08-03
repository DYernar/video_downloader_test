import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_event.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_state.dart';
import 'package:video_downloader/model/video_data.dart';

import '../../util/custom_downloader/custom_downloader.dart';
import '../../util/local_storage/local_storage.dart';

class DownloaderBloc extends Bloc<DownloaderEvent, DownloaderState> {
  final ReceivePort _port = ReceivePort();
  Map<String, int> videoProgress = {};

  DownloaderBloc() : super(InitDownloaderState()) {
    IsolateNameServer.removePortNameMapping(PORT_NAME);
    var res = IsolateNameServer.registerPortWithName(_port.sendPort, PORT_NAME);
    print("REGISTRATION RES $res");
    _port.listen((dynamic data) {
      print("IM HERE LISTENING TO PORT $data");
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      add(NewVideoProgressEvent(id: id, progress: progress));
    });

    on<NewVideoProgressEvent>((event, emit) {
      emit(LoadingDownloaderState());
      videoProgress[event.id] = event.progress;
      emit(NewVideoProgressState(progress: videoProgress));
      var count = 0;
      for (var key in videoProgress.keys) {
        if (videoProgress[key] == 100) {
          count++;
        }
      }
      if (count == videoProgress.length) {
        add(InitDownloaderEvent());
      }
    });

    on<InitDownloaderEvent>((event, emit) async {
      emit(LoadingDownloaderState());
      var videosList = await LocalStorage.getVideos();
      if (videosList.isEmpty) {
        print("START DOWNLOADING");
        videoProgress = {};
        var videoUrls = await _getVideoUrls();
        for (int i = 0; i < videoUrls.length; i++) {
          var res = await CustomDownloader.downloadVideo(videoUrls[i]);
          videosList.add(VideoData(
            url: videoUrls[i],
            path: res.path,
            id: res.taskId,
          ));
        }
        await LocalStorage.saveVideos(videosList);
      } else {
        emit(FinishedDownloadingState(videosList));
      }
    });

    on<ClearDownloadsEvent>((event, emit) async {
      emit(LoadingDownloaderState());
      var allVids = await LocalStorage.getVideos();
      for (int i = 0; i < allVids.length; i++) {
        await CustomDownloader.deleteVideo(allVids[i].path);
      }
      await LocalStorage.removeVideos();
      emit(InitDownloaderState());
    });
  }

  Future<List<String>> _getVideoUrls() async {
    return [
      "https://cdn.videvo.net/videvo_files/video/free/2014-06/large_watermarked/Blue_Sky_and_Clouds_Timelapse_0892__Videvo_preview.mp4",
      "https://cdn.videvo.net/videvo_files/video/premium/video0448/large_watermarked/27_077224992-spikelets-mature-wheat-prick-w_preview.mp4",
      "https://cdn.videvo.net/videvo_files/video/free/2019-12/large_watermarked/190915_B_01_Timelapse%20Danang_05_preview.mp4",
      "https://cdn.videvo.net/videvo_files/video/free/2021-04/large_watermarked/210329_06B_Bali_1080p_013_preview.mp4",
      // "https://cdn.videvo.net/videvo_files/video/free/2014-12/large_watermarked/Raindrops_Videvo_preview.mp4"
    ];
  }
}
