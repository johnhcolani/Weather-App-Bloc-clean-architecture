import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weather_app_clean_bloc/core/params/forecast_params.dart';
import 'package:weather_app_clean_bloc/core/resources/data_state.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/presentation/bloc/cw_status.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/presentation/bloc/fw_status.dart';

import '../../domain/usecases/get_current_weather_usecase.dart';
import '../../domain/usecases/get_forecast_weather_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  final GetForecastWeatherUseCase getForecastWeatherUseCase;
  HomeBloc(this.getCurrentWeatherUseCase,

      this.getForecastWeatherUseCase
      ) : super(HomeState(cwStatus: CwLoading(),
      fwStatus: FwLoading()
  )) {

    on<LoadCwEvent>((event, emit) async {
      emit(state.copyWith(newCwStatus: CwLoading()));
      DataState dataState=await getCurrentWeatherUseCase(event.cityName);
      if(dataState is DataSuccess){
        emit(state.copyWith(newCwStatus: CwCompleted(dataState.data)));
      }
      if(dataState is DataFailed){
        emit(state.copyWith(newCwStatus: CwError((dataState.error!))));
      }
    });

    on<LoadFwEvent>((event, emit) async {
      emit(state.copyWith(newFwStatus: FwLoading()));
      DataState dataState=await getForecastWeatherUseCase(event.forecastParams);
      if(dataState is DataSuccess){
        emit(state.copyWith(newFwStatus: FwCompleted(dataState.data)));
      }
      if(dataState is DataFailed){
        emit(state.copyWith(newFwStatus: FwError((dataState.error!))));
      }
    });
  }
}
