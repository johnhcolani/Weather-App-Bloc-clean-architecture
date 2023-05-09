import 'package:flutter/material.dart';
import 'package:weather_app_clean_bloc/core/widgets/main_wrapper.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/data/data_sourse/remote/api_provider.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/data/repository/weatherRepositoryImpl.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:weather_app_clean_bloc/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  // init locator
  await setup();
  runApp( MaterialApp(
    theme: ThemeData.dark().copyWith(),
    debugShowCheckedModeBanner: false,
    home: MultiBlocProvider(
             providers: [
               BlocProvider(create: (_)=>locator<HomeBloc>()),
             ],
        child: MainWrapper()),
  ));
}

