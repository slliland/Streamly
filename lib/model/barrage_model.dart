import 'dart:convert';
import 'dart:math';

class BarrageModel {
  late String content;
  late String vid;
  late int priority;
  late int type;

  BarrageModel({
    required this.content,
    required this.vid,
    required this.priority,
    required this.type,
  });

  BarrageModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    vid = json['vid'];
    priority = json['priority'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['vid'] = vid;
    data['priority'] = priority;
    data['type'] = type;
    return data;
  }

  /// Parse a JSON string into a list of BarrageModels
  static List<BarrageModel> fromJsonString(String json) {
    List<BarrageModel> list = [];
    if (!(json is String) || !json.startsWith('[')) {
      print('Invalid JSON string');
      return [];
    }

    var jsonArray = jsonDecode(json);
    jsonArray.forEach((v) {
      list.add(BarrageModel.fromJson(v));
    });
    return list;
  }

  /// Allows creating a copy of BarrageModel with some properties changed
  BarrageModel copyWith({
    String? content,
    String? vid,
    int? priority,
    int? type,
  }) {
    return BarrageModel(
      content: content ?? this.content,
      vid: vid ?? this.vid,
      priority: priority ?? this.priority,
      type: type ?? this.type,
    );
  }

  /// Randomize the `type` within a given range
  BarrageModel withRandomType({int min = 1, int max = 5}) {
    int randomType = Random().nextInt(max - min + 1) + min;
    return copyWith(type: randomType);
  }
}
