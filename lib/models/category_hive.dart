import 'package:hive/hive.dart';

part 'category_hive.g.dart';

@HiveType(typeId: 0)
class CategoryHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? parentId;

  @HiveField(3)
  String icon;

  @HiveField(4)
  String color;

  @HiveField(5)
  int level;

  CategoryHive({
    required this.id,
    required this.name,
    this.parentId,
    required this.icon,
    required this.color,
    required this.level,
  });

  CategoryHive copyWith({
    String? id,
    String? name,
    String? parentId,
    String? icon,
    String? color,
    int? level,
  }) {
    return CategoryHive(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      level: level ?? this.level,
    );
  }
}
