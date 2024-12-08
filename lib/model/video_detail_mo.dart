import 'package:streamly/model/video_model.dart';

class VideoDetailMo {
  late bool isFavorite;
  late bool isLike;
  late VideoModel videoInfo;
  late List<VideoModel> videoList;

  VideoDetailMo.fromJson(Map<String, dynamic> json) {
    isFavorite = json['isFavorite'];
    isLike = json['isLike'];
    videoInfo = new VideoModel.fromJson(json['videoInfo']);
    if (json['videoList'] != null) {
      videoList = new List<VideoModel>.empty(growable: true);
      json['videoList'].forEach((v) {
        videoList.add(new VideoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFavorite'] = this.isFavorite;
    data['isLike'] = this.isLike;
    if (this.videoInfo != null) {
      data['videoInfo'] = this.videoInfo.toJson();
    }
    if (this.videoList != null) {
      data['videoList'] = this.videoList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Owner {
  late String name;
  late String face;
  late int fans;

  Owner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    face = json['face'];
    fans = json['fans'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['face'] = this.face;
    data['fans'] = this.fans;
    return data;
  }
}
