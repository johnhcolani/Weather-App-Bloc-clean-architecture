
import 'package:weather_app_clean_bloc/features/feature_weather/domain/entities/current_city_entity.dart';

abstract class CwStatus{}

class CwLoading extends CwStatus{}

class CwCompleted extends CwStatus{

  final CurrentCityEntity currentCityEntity;

  CwCompleted(this.currentCityEntity);
}

class CwError extends CwStatus{
  final String message;

  CwError(this.message);
}