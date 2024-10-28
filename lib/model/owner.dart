class Owner {
  String? name;
  String? face;
  int? fans;

  Owner({this.name, this.face, this.fans});
  Owner.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    face = json['face'] as String?;
    fans = json['fans'] as int?;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['name'] = this.name;
    data['face'] = this.face;
    data['fans'] = this.fans;
    return data;
  }
}
