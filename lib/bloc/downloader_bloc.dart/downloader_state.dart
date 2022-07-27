import 'package:equatable/equatable.dart';

import '../../model/video_data.dart';

abstract class DownloaderState extends Equatable {
  const DownloaderState();
}

class InitDownloaderState extends DownloaderState {
  @override
  List<Object> get props => [];
}

class FailureDownloaderState extends DownloaderState {
  final String error;
  const FailureDownloaderState(this.error);
  @override
  List<Object> get props => [error];
}

class LoadingDownloaderState extends DownloaderState {
  @override
  List<Object> get props => [];
}

class FinishedDownloadingState extends DownloaderState {
  final List<VideoData> videos;

  const FinishedDownloadingState(this.videos);
  @override
  List<Object> get props => [videos];
}

class NewVideoProgressState extends DownloaderState {
  final String id;
  final int progress;
  final List<VideoData> videos;
  const NewVideoProgressState(
      {required this.id, required this.progress, required this.videos});
  @override
  List<Object> get props => [id, progress];
}
