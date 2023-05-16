import 'package:weather_app_clean_bloc/core/params/forecast_params.dart';
import 'package:weather_app_clean_bloc/core/usecase/use_case.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/entities/forecase_days_entity.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/repository/weather_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../entities/current_city_entity.dart';

class GetForecastWeatherUseCase implements UseCase<DataState<ForecastDaysEntity>,ForecastParams >{
  final WeatherRepository _weatherRepository;

  GetForecastWeatherUseCase(this._weatherRepository);

  Future<DataState<ForecastDaysEntity>>call(ForecastParams param){
    return _weatherRepository.fetchForecastWeatherData(param);
  }
}