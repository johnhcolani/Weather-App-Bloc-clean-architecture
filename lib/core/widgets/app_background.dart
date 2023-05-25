import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AppBackground {
  static AssetImage getBackGroundImage() {
    DateTime now = DateTime.now();
    String formatedDate = DateFormat('kk').format(now);
    if (6 > int.parse(formatedDate)) {
      return const AssetImage('assets/images/night_pic.jpg');
    } else if (18 > int.parse(formatedDate)) {
      return const AssetImage('assets/images/day_pics.png');
    } else {
      return const AssetImage('assets/images/night_pic.jpg');
    }
  }

  ///assets/images/icons8-clouds-80.png

  static Image setIconForMain(description) {
    if (description == "clear sky") {
      return const Image(
        image: AssetImage('assets/images/icons8-sun-96.png'));

    } else if (description == 'few clouds') {
      return const Image(
          image: AssetImage('assets/images/icons8-partly-cloudy-day-80.png'));

    } else if (description.contains('clouds')) {
      return const Image(image: AssetImage('assets/images/icons8-clouds-80.png'));

    } else if (description == 'thunderstorm') {
      return const Image(image: AssetImage('assets/images/icons8-storm-80.png'));

    } else if (description == 'drizzle') {
      return const Image(image: AssetImage('assets/images/icons8-rain-clouds-80.png'));

    } else if (description == 'rain') {
      return const Image(image: AssetImage('assets/images/icons8-heavy-rain-80.png'));

    } else if (description == 'snow') {
      return const Image(image: AssetImage('assets/images/icons8-snow-80.png'));

    } else {
      return const Image(image: AssetImage('assets/images/icons8-windy-80.png'));
    }
  }
}
