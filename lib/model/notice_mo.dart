import 'home_mo.dart';

class NoticeMo {
  int? total;
  List<BannerMo> list = []; // Ensure a non-null list

  NoticeMo.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0; // Default to 0 if null
    if (json['list'] != null) {
      list = List<BannerMo>.from(
        json['list'].map((v) => BannerMo.fromJson(v)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}
