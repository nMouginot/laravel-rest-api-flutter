class ItemModel {
  final int id;
  final String name;

  ItemModel({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(id: json['id'] as int, name: json['name'] as String);
  }
}
