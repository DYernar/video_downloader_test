import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_bloc.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_state.dart';
import 'package:video_downloader/screens/failure_screen.dart';
import 'package:video_downloader/screens/init_screen.dart';
import 'package:video_downloader/screens/loading_screen.dart';
import 'package:video_downloader/screens/progress_screen.dart';
import 'package:video_downloader/util/custom_downloader/custom_downloader.dart';
import 'package:video_downloader/util/local_storage/local_storage.dart';

import 'screens/video_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  FlutterDownloader.registerCallback(CustomDownloader.downloadCallback);
  await LocalStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DownloaderBloc _downloaderBloc = DownloaderBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(PORT_NAME);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _downloaderBloc,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: BlocBuilder<DownloaderBloc, DownloaderState>(
            builder: (context, state) {
              if (state is InitDownloaderState) return const InitScreen();
              if (state is LoadingDownloaderState) return const LoadingScreen();
              if (state is FailureDownloaderState) {
                return FailureScreen(error: state.error);
              }
              if (state is FinishedDownloadingState) {
                return const VideoListScreen();
              }
              if (state is NewVideoProgressState) {
                return const ProgressScreen();
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
