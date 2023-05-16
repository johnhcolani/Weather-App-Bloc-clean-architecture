import 'package:dio/dio.dart';
import 'package:weather_app_clean_bloc/core/params/forecast_params.dart';
import 'package:weather_app_clean_bloc/core/resources/data_state.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/data/data_sourse/remote/api_provider.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/data/models/current_city_model.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/data/models/forecast_day_model.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/data/models/suggest_city_model.dart';

import 'package:weather_app_clean_bloc/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/entities/forecase_days_entity.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/entities/suggest_city_entity.dart';

import '../../domain/repository/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  ApiProvider apiProvider;

  WeatherRepositoryImpl(this.apiProvider);

  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(
      String cityName) async {
    try {
      Response response = await apiProvider.callCurrentWeather(cityName);
      if (response.statusCode == 200) {
        CurrentCityEntity currentCityEntity =
            CurrentCityModel.fromJson(response.data);
        return DataSuccess(currentCityEntity);
      } else {
        return const DataFailed('Something went wrong,try again...');
      }
    } catch (e) {
      return const DataFailed('Please check your connection...');
    }
  }

  @override
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(
      ForecastParams params) async {
    try {
      Response response = await apiProvider.sendRequest7DaysForecast(params);
      if (response.statusCode == 200) {
        ForecastDaysEntity forecastDaysEntity =
            ForecastDaysModel.fromJson(response.data);
        return DataSuccess(forecastDaysEntity);
      } else {
        return const DataFailed('Something went wrong,try again...');
      }
    } catch (e) {
      return const DataFailed('Please check your connection...');
    }
  }

  @override
  Future<List<Data>?> fetchSuggetData(cityName) async {}

  @override
  Future<List<Data>> fetchSuggestData(cityName) async {
    Response response = await apiProvider.sendRequestCitySuggestion(cityName);

    SuggestCityEntity suggestCityEntity =
        SuggestCityModel.fromJson(response.data);
    return suggestCityEntity.data!;
  }
}
