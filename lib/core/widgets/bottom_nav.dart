import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/data/data_source/remote/api_provider.dart';

class BottomNav extends StatefulWidget {
  PageController Controller;
  BottomNav({Key? key, required this.Controller}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  ApiProvider apiProvider = ApiProvider();
  Color colour = Colors.grey;
  String textC = '\u00B0C';
  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    TextTheme textTheme = Theme.of(context).textTheme;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      color: primaryColor,
      child: SizedBox(
        height: 63,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  widget.Controller.animateToPage(0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                icon: const Icon(Icons.home)),
            //const SizedBox(),
            TextButton(
                onPressed: () {
                  setState(() {
                    if (textC == '\u00B0C' && apiProvider.unit == 'metric') {
                      apiProvider.unit = 'imperial';
                      textC = '\u00B0F';
                    } else {
                      textC = '\u00B0C';
                      apiProvider.unit = 'metric';
                    }
                  });
                },
                child: Text(
                  textC,
                  style: TextStyle(fontSize: 16.sp, color: colour),
                )),

            //const SizedBox(),
            IconButton(
                onPressed: () {
                  widget.Controller.animateToPage(1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                icon: const Icon(Icons.bookmark)),
          ],
        ),
      ),
    );
  }
}
