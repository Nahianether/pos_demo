class Category {
  final String id;
  final String name;
  final String? parentId;
  final String icon;
  final String color;
  final int level;

  Category({
    required this.id,
    required this.name,
    this.parentId,
    required this.icon,
    required this.color,
    required this.level,
  });

  Category copyWith({
    String? id,
    String? name,
    String? parentId,
    String? icon,
    String? color,
    int? level,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      level: level ?? this.level,
    );
  }
}
