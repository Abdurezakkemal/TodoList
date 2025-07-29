import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 3) // Use a unique typeId
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int colorValue;

  Category({
    required this.id,
    required this.name,
    required this.colorValue,
  });

  // Create a copyWith method for immutability
  Category copyWith({
    String? id,
    String? name,
    int? colorValue,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
