import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_bloc.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_state.dart';
import 'package:video_downloader/model/video_data.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<String, double> progressses = {};
  List<VideoData> videos = [];
  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloaderBloc, DownloaderState>(
      listener: (context, state) {
        if (state is NewVideoProgressState) {
          setState(() {
            videos = state.videos;
            progressses[state.id] = state.progress / 100;
          });
        }
      },
      child: _buildProgress(),
    );
  }

  Widget _buildProgress() {
    List<Widget> progressWidgets = [];
    for (var video in videos) {
      progressWidgets
          .add(_buildSingleProgress(video, progressses[video.id] ?? 0.0));
    }
    return ListView(children: progressWidgets);
  }

  Widget _buildSingleProgress(VideoData video, double progress) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(video.path),
          LinearProgressIndicator(
            value: progress,
          ),
        ],
      ),
    );
  }
}
