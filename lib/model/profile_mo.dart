import 'home_mo.dart';

class ProfileMo {
  late String name;
  late String face;
  late int fans;
  late int favorite;
  late int like;
  late int coin;
  late int browsing;
  late List<BannerMo> bannerList;
  late List<Course> courseList;
  late List<Benefit> benefitList;

  ProfileMo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    face = json['face'];
    fans = json['fans'];
    favorite = json['favorite'];
    like = json['like'];
    coin = json['coin'];
    browsing = json['browsing'];
    if (json['bannerList'] != null) {
      bannerList = new List<BannerMo>.empty(growable: true);
      json['bannerList'].forEach((v) {
        bannerList.add(new BannerMo.fromJson(v));
      });
    }
    if (json['courseList'] != null) {
      courseList = new List<Course>.empty(growable: true);
      json['courseList'].forEach((v) {
        courseList.add(new Course.fromJson(v));
      });
    }
    if (json['benefitList'] != null) {
      benefitList = new List<Benefit>.empty(growable: true);
      json['benefitList'].forEach((v) {
        benefitList.add(new Benefit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['face'] = this.face;
    data['fans'] = this.fans;
    data['favorite'] = this.favorite;
    data['like'] = this.like;
    data['coin'] = this.coin;
    data['browsing'] = this.browsing;
    data['bannerList'] = this.bannerList.map((v) => v.toJson()).toList();
    data['courseList'] = this.courseList.map((v) => v.toJson()).toList();
    data['benefitList'] = this.benefitList.map((v) => v.toJson()).toList();
    return data;
  }
}

class Course {
  late String name;
  late String cover;
  late String url;
  late int group;

  Course.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cover = json['cover'];
    url = json['url'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['cover'] = this.cover;
    data['url'] = this.url;
    data['group'] = this.group;
    return data;
  }
}

class Benefit {
  late String name;
  late String url;

  Benefit.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
