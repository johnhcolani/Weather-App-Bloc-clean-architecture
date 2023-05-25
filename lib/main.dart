import 'package:flutter/material.dart';
import 'package:weather_app_clean_bloc/core/widgets/main_wrapper.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:weather_app_clean_bloc/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init locator
  await setup();
  runApp(

      Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            theme: ThemeData.dark().copyWith(),
            debugShowCheckedModeBanner: false,
            home: MultiBlocProvider(providers: [
              BlocProvider(create: (_) => locator<HomeBloc>()),
              BlocProvider(create: (_) => locator<BookmarkBloc>()),
            ], child: MainWrapper()),
          );

        },

      )
  );
}
