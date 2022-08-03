import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_bloc.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_state.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<String, int> progressses = {};
  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloaderBloc, DownloaderState>(
      listener: (context, state) {
        if (state is NewVideoProgressState) {
          setState(() {
            progressses = state.progress;
          });
        }
      },
      child: _buildProgress(),
    );
  }

  Widget _buildProgress() {
    List<Widget> progressWidgets = [];
    for (var id in progressses.keys) {
      progressWidgets.add(_buildSingleProgress(id, progressses[id] ?? 0.0));
    }
    return ListView(children: progressWidgets);
  }

  Widget _buildSingleProgress(String id, num progress) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("id $id progress $progress"),
          LinearProgressIndicator(value: progress.toDouble() / 100),
        ],
      ),
    );
  }
}
