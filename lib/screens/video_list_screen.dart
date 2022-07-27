import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_event.dart';
import 'package:video_downloader/bloc/downloader_bloc.dart/downloader_state.dart';

import '../bloc/downloader_bloc.dart/downloader_bloc.dart';
import '../model/video_data.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: BlocBuilder<DownloaderBloc, DownloaderState>(
                builder: (context, state) {
              if (state is FinishedDownloadingState) {
                return _buildPost(state.videos);
              }
              return Container();
            }),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<DownloaderBloc>(context)
                  .add(ClearDownloadsEvent());
            },
            child: const Text("remove all downloads"),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(List<VideoData> videos) {
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                aspectRatio: 1,
                height: 500,
                viewportFraction: 1,
                scrollPhysics: const BouncingScrollPhysics(),
                onPageChanged: (index, reason) {
                  setState(() {
                    currentPage = index;
                  });
                },
              ),
              items: videos.map((v) {
                return Builder(
                  builder: (BuildContext context) {
                    return _buildBody(v.path);
                  },
                );
              }).toList(),
            ),
            const Positioned(
              left: 20,
              top: 20,
              child: Text(
                "This is some text about the video",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: videos.map((e) => _buildDot(videos.indexOf(e))).toList(),
        ),
        _buildLikes(videos),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Нравится: 41 209"),
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "Simply create a CarouselSlider widget, and pass the required params"),
          ),
        ),
      ],
    );
  }

  Widget _buildLikes(List<VideoData> videos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(
                Icons.heart_broken_outlined,
                size: 35,
              ),
              Icon(
                Icons.send,
                size: 35,
              ),
              Icon(
                Icons.message_outlined,
                size: 35,
              ),
            ],
          ),
          const Icon(
            Icons.bookmark_add_outlined,
            size: 35,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int ind) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ind == currentPage ? Colors.blue : Colors.grey,
      ),
    );
  }

  Widget _buildBody(String path) {
    return NativeVideoView(
      showMediaController: false,
      onCreated: (controller) {
        controller.setVideoSource(
          path,
          sourceType: VideoSourceType.file,
        );
      },
      onPrepared: (controller, info) {
        controller.play();
      },
      onError: (controller, what, extra, message) {
        print('Player Error ($what | $extra | $message)');
      },
      onCompletion: (controller) {
        print('Video completed');
      },
      onProgress: (progress, duration) {
        print('$progress | $duration');
      },
    );
  }
}
