import 'package:hive/hive.dart';
import 'models/local_cities.dart';

class Boxes {
  static Box<LocalCity> getHiveLocalCityBox() => Hive.box<LocalCity>('localCityBox');
}
