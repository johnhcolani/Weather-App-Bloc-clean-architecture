import 'package:flutter/material.dart';
import 'package:weather_app_clean_bloc/core/widgets/app_background.dart';
import 'package:weather_app_clean_bloc/core/widgets/bottom_nav.dart';
import 'package:weather_app_clean_bloc/features/feature_bookmark/presentation/screens/bookmark_screen.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/presentation/screens/home_screen.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({Key? key}) : super(key: key);

  final PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    List<Widget> pageViewWidget = [
      const HomeScreen(),
      const BookmarkScreen(),
    ];
    double he= MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNav(controller: pageController,),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AppBackground.getBackGroundImage(),
          fit: BoxFit.cover
          ),

        ),
        height:he ,
        child: PageView(
          controller: pageController,
          children: pageViewWidget,
        ),
      ),
    );
  }
}
