class HomeMo {
  List<BannerMo>? bannerList;
  List<CategoryMo>? categoryList;
  List<VideoMo>? videoList;

  HomeMo({this.bannerList, this.categoryList, this.videoList});

  HomeMo.fromJson(Map<String, dynamic> json) {
    if (json['bannerList'] != null) {
      bannerList = <BannerMo>[];
      json['bannerList'].forEach((v) {
        bannerList!.add(new BannerMo.fromJson(v));
      });
    }
    if (json['categoryList'] != null) {
      categoryList = <CategoryMo>[];
      json['categoryList'].forEach((v) {
        categoryList!.add(new CategoryMo.fromJson(v));
      });
    }
    if (json['videoList'] != null) {
      videoList = <VideoMo>[];
      json['videoList'].forEach((v) {
        videoList!.add(new VideoMo.fromJson(v));
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
    if (this.videoList != null) {
      data['videoList'] = this.videoList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerMo {
  String? id;
  int? sticky;
  String? type;
  String? title;
  String? subtitle;
  String? url;
  String? cover;
  String? createTime;

  BannerMo(
      {this.id,
      this.sticky,
      this.type,
      this.title,
      this.subtitle,
      this.url,
      this.cover,
      this.createTime});

  BannerMo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sticky = json['sticky'];
    type = json['type'];
    title = json['title'];
    subtitle = json['subtitle'];
    url = json['url'];
    cover = json['cover'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sticky'] = this.sticky;
    data['type'] = this.type;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['url'] = this.url;
    data['cover'] = this.cover;
    data['createTime'] = this.createTime;
    return data;
  }
}

class CategoryMo {
  String? name;
  int? count;

  CategoryMo({this.name, this.count});

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

class VideoMo {
  String? id;
  String? vid;
  String? title;
  String? tname;
  String? url;
  String? cover;
  int? pubdate;
  String? desc;
  int? view;
  int? duration;
  Owner? owner;
  int? reply;
  int? favorite;
  int? like;
  int? coin;
  int? share;
  String? createTime;
  int? size;

  VideoMo(
      {this.id,
      this.vid,
      this.title,
      this.tname,
      this.url,
      this.cover,
      this.pubdate,
      this.desc,
      this.view,
      this.duration,
      this.owner,
      this.reply,
      this.favorite,
      this.like,
      this.coin,
      this.share,
      this.createTime,
      this.size});

  VideoMo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vid = json['vid'];
    title = json['title'];
    tname = json['tname'];
    url = json['url'];
    cover = json['cover'];
    pubdate = json['pubdate'];
    desc = json['desc'];
    view = json['view'];
    duration = json['duration'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    reply = json['reply'];
    favorite = json['favorite'];
    like = json['like'];
    coin = json['coin'];
    share = json['share'];
    createTime = json['createTime'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vid'] = this.vid;
    data['title'] = this.title;
    data['tname'] = this.tname;
    data['url'] = this.url;
    data['cover'] = this.cover;
    data['pubdate'] = this.pubdate;
    data['desc'] = this.desc;
    data['view'] = this.view;
    data['duration'] = this.duration;
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    data['reply'] = this.reply;
    data['favorite'] = this.favorite;
    data['like'] = this.like;
    data['coin'] = this.coin;
    data['share'] = this.share;
    data['createTime'] = this.createTime;
    data['size'] = this.size;
    return data;
  }
}

class Owner {
  String? name;
  String? face;
  int? fans;

  Owner({this.name, this.face, this.fans});

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
