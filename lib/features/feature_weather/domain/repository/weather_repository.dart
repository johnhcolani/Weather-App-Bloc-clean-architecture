import 'package:weather_app_clean_bloc/core/resources/data_state.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/entities/current_city_entity.dart';

abstract class WeatherRepository {
Future<DataState<CurrentCityEntity>>fetchCurrentWeatherData(String cityName);
}