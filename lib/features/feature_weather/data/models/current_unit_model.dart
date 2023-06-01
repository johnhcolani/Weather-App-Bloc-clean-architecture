import 'package:weather_app_clean_bloc/features/feature_weather/domain/entities/current_unit_entity.dart';

class CurrentUnitModel extends CurrentUnitEntity{

  final String unit;

  const CurrentUnitModel(this.unit) : super('');
}