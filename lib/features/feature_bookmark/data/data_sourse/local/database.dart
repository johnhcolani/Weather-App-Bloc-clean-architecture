
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:weather_app_clean_bloc/features/feature_bookmark/data/data_sourse/local/city_dao.dart';

import '../../../domain/entities/city_entity.dart';



part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [City])
abstract class AppDatabase extends FloorDatabase {
  CityDao get cityDao;
}