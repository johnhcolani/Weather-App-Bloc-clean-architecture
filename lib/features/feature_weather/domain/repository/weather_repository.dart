

import '../../../../core/params/ForecastParams.dart';
import '../../../../core/resources/data_state.dart';
import '../../data/models/suggest_city_model.dart';
import '../entities/current_city_entity.dart';
import '../entities/forecase_days_entity.dart';

abstract class WeatherRepository{

  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);

  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params);

  Future<List<Data>> fetchSuggestData(cityName);

}