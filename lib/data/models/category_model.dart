class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({
    required this.name,
    required this.icon,
    required this.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['_id'],
        name: json['name'],
        icon: json['icon'],
      );
}
