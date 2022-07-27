import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_bloc.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_event.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            BlocProvider.of<DownloaderBloc>(context).add(InitDownloaderEvent());
          },
          child: const Text("download videos"),
        ),
      ),
    );
  }
}
