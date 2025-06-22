// models/local_city.dart
import 'package:hive/hive.dart';

part 'local_cities.g.dart';

@HiveType(typeId: 1)
class LocalCity extends HiveObject {
  @HiveField(0)
  String name;

  LocalCity({required this.name});
}
