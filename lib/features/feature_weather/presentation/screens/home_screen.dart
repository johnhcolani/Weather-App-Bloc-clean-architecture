import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app_clean_bloc/core/params/forecast_params.dart';
import 'package:weather_app_clean_bloc/core/widgets/app_background.dart';
import 'package:weather_app_clean_bloc/core/widgets/dot_loading_widget.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/usecases/get_suggestion_city_usecase.dart';

import 'package:weather_app_clean_bloc/features/feature_weather/presentation/bloc/cw_status.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:weather_app_clean_bloc/locator.dart';
import '../../../../core/utils/date_converter.dart';
import '../../data/models/forecast_day_model.dart';
import '../../data/models/suggest_city_model.dart';
import '../../domain/entities/current_city_entity.dart';
import '../../domain/entities/forecase_days_entity.dart';
import '../widgets/days_weather_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController=TextEditingController();
  GetSuggestionCityUseCase getSuggestionCityUseCase=GetSuggestionCityUseCase(locator());
  final PageController _pageController = PageController();
  String cityName = 'Henrico';
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
          SizedBox(height: he*0.005,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: wi*0.03),
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                onSubmitted: (String prefix){
                  textEditingController.text=prefix;
                  BlocProvider.of<HomeBloc>(context)
                  .add(LoadCwEvent(prefix));
                },
                controller: textEditingController,
                style: DefaultTextStyle.of(context).style.copyWith(
                  fontSize: 20,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  contentPadding:
                    EdgeInsets.fromLTRB(20, 0, 0, 0),
                  hintText: "Enter a City ...",
                  hintStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),

                )
              ),
                suggestionsCallback: (String prefix){
                  return getSuggestionCityUseCase(prefix);
                },
                itemBuilder: (context,Data model){
                 return ListTile(
                   leading: const Icon(Icons.location_on),
                   title: Text(model.name!),
                   subtitle: Text('${model.region!},${model.country}'),
                 );
                },
                onSuggestionSelected: (Data model){
                  textEditingController.text=model.name!;
                  BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(model.name!));
                }),
          ),
          BlocBuilder<HomeBloc, HomeState>(buildWhen: (previous, current) {
            if (previous.cwStatus == current.cwStatus) {
              return false;
            }
            return true;
          }, builder: (context, state) {
            if (state.cwStatus is CwLoading) {
              return const Expanded(
                child: DotLoadingWidget(),
              );
            }
            if (state.cwStatus is CwCompleted) {
              final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
              final CurrentCityEntity currentCityEntity =
                  cwCompleted.currentCityEntity;

              //create params for api call
              final ForecastParams forecastParams = ForecastParams(
                  currentCityEntity.coord!.lat!.toDouble(),
                  currentCityEntity.coord!.lon!.toDouble());
              // start load Fw event
              BlocProvider.of<HomeBloc>(context)
                  .add(LoadFwEvent(forecastParams));

// change times to hour -- 5:55 AM/PM
              final sunrise = DateConverter.changeDtToDateTimeHour(
                  currentCityEntity.sys!.sunrise, currentCityEntity.timezone);
              final sunset = DateConverter.changeDtToDateTimeHour(
                  currentCityEntity.sys!.sunset, currentCityEntity.timezone);

              return Expanded(
                  child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: he * 0.01),
                    child: SizedBox(
                      width: wi,
                      height: he *0.47,
                      child: PageView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          allowImplicitScrolling: true,
                          controller: _pageController,
                          itemCount: 2,
                          itemBuilder: (context, position) {
                            if (position == 0) {
                              return Column(
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
                                      currentCityEntity
                                          .weather![0].description!,
                                      style: GoogleFonts.mcLaren(fontSize: 20),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: AppBackground.setIconForMain(
                                        currentCityEntity
                                            .weather![0].description!),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      '${currentCityEntity.main!.temp!.round().toString()}\u00B0',
                                      style: GoogleFonts.mcLaren(fontSize: 56),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          const Text('max'),
                                          Text(
                                            '${currentCityEntity.main!.tempMax!.round().toString()}\u00B0',
                                            style: GoogleFonts.mcLaren(
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          color: Colors.white,
                                          height: 40,
                                          width: 1,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          const Text('min'),
                                          Text(
                                            '${currentCityEntity.main!.tempMin!.round().toString()}\u00B0',
                                            style: GoogleFonts.mcLaren(
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                                color: const Color(0xFFE7D87C),
                              );
                            }
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 2,
                      effect: const ExpandingDotsEffect(
                        dotWidth: 10,
                        dotHeight: 10,
                        spacing: 5,
                        activeDotColor: Colors.white,
                      ),
                      onDotClicked: (index) => _pageController.animateToPage(
                          index,
                          duration: const Duration(microseconds: 500),
                          curve: Curves.bounceInOut),
                    ),
                  ),
                  // divider
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      color: Colors.white24,
                      height: 2,
                      width: double.infinity,
                    ),
                  ),
                  // forecast weather 7 days
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: SizedBox(
                      width: double.infinity,
                      height: he*0.11,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Center(
                          child: BlocBuilder<HomeBloc, HomeState>(
                            buildWhen: (previous, current) {
                              if (previous.fwStatus == current.fwStatus) {
                                return false;
                              }
                              return true;
                            },
                            builder: (BuildContext context, state) {
                              // show loading state for Fw
                              if (state.fwStatus is FwLoading) {
                                return const DotLoadingWidget();
                              }
                              // show completed sate for Fw
                              if (state.fwStatus is FwCompleted) {
                                // casting
                                final FwCompleted fwCompleted =
                                    state.fwStatus as FwCompleted;
                                final ForecastDaysEntity forecastDaysEntity =
                                    fwCompleted.forecastDaysEntity;
                                final List<Daily> mainDaily =
                                    forecastDaysEntity.daily!;
                                return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 8,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return DaysWeatherView(
                                          daily: mainDaily[index]);
                                    });
                              }
                              if (state.fwStatus is FwError) {
                                final FwError fwError =
                                    state.fwStatus as FwError;
                                return Center(
                                  child: Text(fwError.message),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // divider
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Container(
                      color: Colors.white24,
                      height: 2,
                      width: double.infinity,
                    ),
                  ),
                   SizedBox(
                    height: he*0.01,
                  ),
                  // last row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "wind speed",
                            style: TextStyle(
                              fontSize: he * 0.017,
                              color: Colors.amber,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              "${currentCityEntity.wind!.speed!} m/s",
                              style: TextStyle(
                                fontSize: he * 0.016,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          color: Colors.white54,
                          height: 30,
                          width: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            Text(
                              'sunrise',
                              style: TextStyle(
                                  fontSize: he * 0.017, color: Colors.amber),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                sunrise,
                                style: TextStyle(
                                    fontSize: he * 0.016, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          color: Colors.white24,
                          height: 30,
                          width: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            Text(
                              'sunset',
                              style: TextStyle(
                                  fontSize: he * 0.017, color: Colors.amber),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                sunset,
                                style: TextStyle(
                                    fontSize: he * 0.016, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          color: Colors.white24,
                          height: 30,
                          width: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: [
                            Text(
                              "humidity",
                              style: TextStyle(
                                fontSize: he * 0.017,
                                color: Colors.amber,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "${currentCityEntity.main!.humidity!}%",
                                style: TextStyle(
                                  fontSize: he * 0.016,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ));
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
