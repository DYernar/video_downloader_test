class VideoData {
  final String path;
  final String url;
  final String id;
  VideoData({required this.path, required this.url, required this.id});

  List<VideoData> parseList(List<dynamic> list) {
    return list.map((e) => VideoData.fromJson(e)).toList();
  }

  VideoData.fromJson(Map<String, dynamic> json)
      : path = json['path'],
        url = json['url'],
        id = json['id'];

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'url': url,
      'id': id,
    };
  }
}
