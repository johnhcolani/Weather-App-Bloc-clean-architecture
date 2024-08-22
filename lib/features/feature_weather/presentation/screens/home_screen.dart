import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/params/ForecastParams.dart';
import '../../../../core/utils/date_converter.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/dot_loading_widget.dart';
import '../../../../locator.dart';
import '../../../feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import '../../data/models/ForcastDaysModel.dart';
import '../../data/models/suggest_city_model.dart';
import '../../domain/entities/current_city_entity.dart';
import '../../domain/entities/forecase_days_entity.dart';
import '../../domain/use_cases/get_suggestion_city_usecase.dart';
import '../bloc/cw_status.dart';
import '../bloc/fw_status.dart';
import '../bloc/home_bloc.dart';
import '../widgets/bookmark_icon.dart';
import '../widgets/day_weather_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController textEditingController = TextEditingController();

  GetSuggestionCityUseCase getSuggestionCityUseCase =
      GetSuggestionCityUseCase(locator());

  String cityName = "Richmond";
  final PageController _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: height * 0.02,
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Row(
            children: [
              /// search box
              Expanded(
                child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      onSubmitted: (String prefix) {
                        textEditingController.text = prefix;
                        BlocProvider.of<HomeBloc>(context)
                            .add(LoadCwEvent(prefix));
                      },
                      controller: textEditingController,
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        hintText: "Enter a City...",
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    suggestionsCallback: (String prefix) {
                      return getSuggestionCityUseCase(prefix);
                    },
                    itemBuilder: (context, Data model) {
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(model.name!),
                        subtitle: Text("${model.region!}, ${model.country!}"),
                      );
                    },
                    onSuggestionSelected: (Data model) {
                      textEditingController.text = model.name!;
                      BlocProvider.of<HomeBloc>(context)
                          .add(LoadCwEvent(model.name!));
                    }),
              ),

              const SizedBox(
                width: 10,
              ),

              BlocBuilder<HomeBloc, HomeState>(buildWhen: (previous, current) {
                if (previous.cwStatus == current.cwStatus) {
                  return false;
                }
                return true;
              }, builder: (context, state) {
                /// show Loading State for Cw
                if (state.cwStatus is CwLoading) {
                  return const CircularProgressIndicator();
                }

                /// show Error State for Cw
                if (state.cwStatus is CwError) {
                  return IconButton(
                    onPressed: () {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text("please load a city!"),
                      //   behavior: SnackBarBehavior.floating, // Add this line
                      // ));
                    },
                    icon:
                        const Icon(Icons.error, color: Colors.white, size: 35),
                  );
                }

                if (state.cwStatus is CwCompleted) {
                  final CwCompleted cwComplete = state.cwStatus as CwCompleted;
                  BlocProvider.of<BookmarkBloc>(context).add(
                      GetCityByNameEvent(cwComplete.currentCityEntity.name!));
                  return BookMarkIcon(name: cwComplete.currentCityEntity.name!);
                }

                return Container();
              }),
            ],
          ),
        ),

        /// main UI
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) {
            /// rebuild just when CwStatus Changed
            if (previous.cwStatus == current.cwStatus) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            if (state.cwStatus is CwLoading) {
              return const Expanded(child: DotLoadingWidget());
            }

            if (state.cwStatus is CwCompleted) {
              /// cast
              final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
              final CurrentCityEntity currentCityEntity =
                  cwCompleted.currentCityEntity;

              /// create params for api call
              final ForecastParams forecastParams = ForecastParams(
                  currentCityEntity.coord!.lat!, currentCityEntity.coord!.lon!);

              /// start load Fw event
              BlocProvider.of<HomeBloc>(context)
                  .add(LoadFwEvent(forecastParams));

              /// change Times to Hour --5:55 AM/PM----
              final sunrise = DateConverter.changeDtToDateTimeHour(
                  currentCityEntity.sys!.sunrise, currentCityEntity.timezone);
              final sunset = DateConverter.changeDtToDateTimeHour(
                  currentCityEntity.sys!.sunset, currentCityEntity.timezone);

              return Expanded(
                  child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: SizedBox(
                      width: width,
                      height: 43.h,
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
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: Text(
                                    currentCityEntity.name!,
                                    style: TextStyle(
                                        fontSize: 25.sp, color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    currentCityEntity.weather![0].description!,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.amber.shade200),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: AppBackground.setIconForMain(
                                      currentCityEntity
                                          .weather![0].description!),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    "${currentCityEntity.main!.temp!.round()}\u00B0",
                                    style: TextStyle(
                                        fontSize: 45.sp, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /// max temp
                                    Column(
                                      children: [
                                        Text(
                                          "max",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.amber.shade200,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          "${currentCityEntity.main!.tempMax!.round()}\u00B0",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),

                                    /// divider
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 2.w,
                                        right: 2.w,
                                      ),
                                      child: Container(
                                        color: Colors.grey,
                                        width: 0.5.w,
                                        height: 4.h,
                                      ),
                                    ),

                                    /// min temp
                                    Column(
                                      children: [
                                        Text(
                                          "min",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.amber.shade200,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          "${currentCityEntity.main!.tempMin!.round()}\u00B0",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            );
                          } else {
                            return Container(
                              color: Colors.white.withOpacity(0.1),
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  /// pageView Indicator
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      // PageController
                      count: 2,
                      effect: ExpandingDotsEffect(
                        dotWidth: 3.w,
                        dotHeight: 1.h,
                        spacing: 5,
                        activeDotColor: Colors.white,
                      ),
                      // your preferred effect
                      onDotClicked: (index) => _pageController.animateToPage(
                        index,
                        duration: const Duration(microseconds: 500),
                        curve: Curves.bounceOut,
                      ),
                    ),
                  ),

                  /// divider
                  Padding(
                    padding: EdgeInsets.only(top: 3.h),
                    child: Container(
                      color: Colors.white24,
                      height: 0.2.h,
                      width: double.infinity,
                    ),
                  ),

                  /// forecast weather 7 days
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: SizedBox(
                      width: double.infinity,
                      height: 12.h,
                      child: Padding(
                        padding: EdgeInsets.only(left: 1.h),
                        child: Center(
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (BuildContext context, state) {
                              /// show Loading State for Fw
                              if (state.fwStatus is FwLoading) {
                                return const DotLoadingWidget();
                              }

                              /// show Completed State for Fw
                              if (state.fwStatus is FwCompleted) {
                                /// casting
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
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return DaysWeatherView(
                                      daily: mainDaily[index],
                                    );
                                  },
                                );
                              }

                              /// show Error State for Fw
                              if (state.fwStatus is FwError) {
                                final FwError fwError =
                                    state.fwStatus as FwError;
                                return Center(
                                  child: Text(fwError.message!),
                                );
                              }

                              /// show Default State for Fw
                              return Container();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// divider
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Container(
                      color: Colors.white24,
                      height: 0.2.h,
                      width: double.infinity,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  /// last Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "wind speed",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.amber.shade200,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Text(
                              "${currentCityEntity.wind!.speed!} m/s",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Container(
                          color: Colors.white24,
                          height: 4.h,
                          width: 0.5.w,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Column(
                          children: [
                            Text(
                              "sunrise",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.amber.shade200,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(
                                sunrise,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Container(
                          color: Colors.white24,
                          height: 4.h,
                          width: 0.5.w,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Column(
                          children: [
                            Text(
                              "sunset",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.amber.shade200,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(
                                sunset,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Container(
                          color: Colors.white24,
                          height: 4.h,
                          width: 0.5.w,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Column(
                          children: [
                            Text(
                              "humidity",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.amber.shade200,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Text(
                                "${currentCityEntity.main!.humidity!}%",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 4.h,
                  ),
                ],
              ));
            }

            if (state.cwStatus is CwError) {
              return const Center(
                child: Text(
                  'error',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Container();
          },
        ),
      ],
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
