import 'video_model.dart';

class HomeMo {
  List<BannerMo>? bannerList;
  List<CategoryMo>? categoryList;
  late List<VideoModel> videoList;

  HomeMo({this.bannerList, this.categoryList, required this.videoList});

  HomeMo.fromJson(Map<String, dynamic> json) {
    if (json['bannerList'] != null) {
      bannerList = new List<BannerMo>.empty(growable: true);
      json['bannerList'].forEach((v) {
        bannerList!.add(new BannerMo.fromJson(v));
      });
    }
    if (json['categoryList'] != null) {
      categoryList = new List<CategoryMo>.empty(growable: true);
      json['categoryList'].forEach((v) {
        categoryList!.add(new CategoryMo.fromJson(v));
      });
    }
    if (json['videoList'] != null) {
      videoList = new List<VideoModel>.empty(growable: true);
      json['videoList'].forEach((v) {
        videoList.add(new VideoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bannerList != null) {
      data['bannerList'] = this.bannerList!.map((v) => v.toJson()).toList();
    }
    if (this.categoryList != null) {
      data['categoryList'] = this.categoryList!.map((v) => v.toJson()).toList();
    }
    data['videoList'] = this.videoList.map((v) => v.toJson()).toList();
    return data;
  }
}

class BannerMo {
  String? id;
  String? sticky;
  String? type;
  String? title;
  String? subtitle;
  String? url;
  String? cover;
  String? createTime;

  BannerMo.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? ''; // Default empty string for null values
    sticky = json['sticky']?.toString() ?? '';
    type = json['type'] ?? '';
    title = json['title'] ?? 'Untitled';
    subtitle = json['subtitle'] ?? 'No subtitle available';
    url = json['url'] ?? '';
    cover = json['cover'] ?? '';
    createTime = json['createTime'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sticky'] = sticky;
    data['type'] = type;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['url'] = url;
    data['cover'] = cover;
    data['createTime'] = createTime;
    return data;
  }
}

class CategoryMo {
  late String name;
  late int count;

  CategoryMo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    return data;
  }
}
