import 'package:equatable/equatable.dart';

abstract class DownloaderEvent extends Equatable {}

class InitDownloaderEvent extends DownloaderEvent {
  @override
  List<Object> get props => [];
}

class ClearDownloadsEvent extends DownloaderEvent {
  @override
  List<Object> get props => [];
}

class NewVideoProgressEvent extends DownloaderEvent {
  final String id;
  final int progress;
  NewVideoProgressEvent({required this.id, required this.progress});
  @override
  List<Object> get props => [id, progress];
}
