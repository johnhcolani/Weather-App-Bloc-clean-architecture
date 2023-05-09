import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app_clean_bloc/core/widgets/app_background.dart';
import 'package:weather_app_clean_bloc/core/widgets/dot_loading_widget.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/presentation/bloc/cw_status.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/presentation/bloc/home_bloc.dart';

import '../../domain/entities/current_city_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String cityName = 'Richmond';
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final he = MediaQuery.of(context).size.height;
    final wi = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state.cwStatus is CwLoading) {
              return const Expanded(
                child: DotLoadingWidget(),
              );
            }
            if (state.cwStatus is CwCompleted) {
              final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
              final CurrentCityEntity currentCityEntity =
                  cwCompleted.currentCityEntity;

              return Expanded(
                child: ListView(children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Text(
                          currentCityEntity.name.toString(),
                          style: GoogleFonts.mcLaren(fontSize: 36),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          currentCityEntity.weather![0].description!,
                          style: GoogleFonts.mcLaren(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: AppBackground.setIconForMain(
                            currentCityEntity.weather![0].description!),
                      ),
                    ],
                  ),
                ]),
              );
            }
            if (state.cwStatus is CwError) {
              return const Center(
                child: Text('Error'),
              );
            }

            return Container();
          }),
        ],
      ),
    );
  }
}
