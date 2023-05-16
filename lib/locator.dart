
import 'package:get_it/get_it.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/data/data_sourse/remote/api_provider.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/data/repository/weatherRepositoryImpl.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/usecases/get_forecast_weather_usecase.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/presentation/bloc/home_bloc.dart';

GetIt locator = GetIt.instance;
setup(){
  locator.registerSingleton<ApiProvider>(ApiProvider());
  // repository
  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(locator()));
  // use case
  locator.registerSingleton<GetCurrentWeatherUseCase>(GetCurrentWeatherUseCase(locator()));
  locator.registerSingleton<GetForecastWeatherUseCase>(GetForecastWeatherUseCase(locator()));
  // bloc
  locator.registerSingleton<HomeBloc>(HomeBloc(locator(),locator()));

}