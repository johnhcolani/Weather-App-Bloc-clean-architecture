import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_clean_bloc/core/utils/date_converter.dart';

void main() {
  group('ChangeDtToDateTime test', () {
    test('Should be return --Aug 10---', () {
      var result = DateConverter.changeDtToDateTime(1660127867);
      expect(result, 'Aug 10');
    });

    test('should be return ---Jan 27---', () {
      var result = DateConverter.changeDtToDateTime(16601278673);
      expect(result, 'Jan 27');
    });
  });

  group('changeDtToDateTimeHour test', () {
    String expectedTime = "10:39 AM";
    String actualTime = "10:39 AM";
    String cleanedActualTime = actualTime.replaceAll("\u202F", " ");
    if (expectedTime==cleanedActualTime) {
      test('should be return $expectedTime', () {
        var result = DateConverter.changeDtToDateTimeHour(166012786, 0);
        expect(result, actualTime);
      });
    } else {
      print("The times are different.");
    }
  }
  );
}



