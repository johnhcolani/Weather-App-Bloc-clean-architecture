import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_clean_bloc/core/widgets/bottom_nav.dart';

void main(){
  testWidgets('click IconButton in bottom nav should navigate us to page 0 in page view', (tester) async {
    PageController pageController=PageController();
 await tester.pumpWidget(
     MaterialApp(
         home:Scaffold(
           bottomNavigationBar: BottomNav(Controller: pageController),
           body: PageView(
             controller: pageController,
             children: [
               Container(),
               Container()
             ],
           ),
         )));
 await tester.tap(find.widgetWithIcon(IconButton,Icons.home));

 await tester.pumpAndSettle();
 expect(pageController.page, 0);

  });


  testWidgets('click IconButton in bottom nav should navigate us to page 1 in page view', (tester) async {
   // build widget
    PageController pageController=PageController();
    await tester.pumpWidget(
        MaterialApp(
            home:Scaffold(
              bottomNavigationBar: BottomNav(Controller: pageController),
              body: PageView(
                controller: pageController,
                children: [
                  Container(),
                  Container()
                ],
              ),
            )));
    await tester.tap(find.widgetWithIcon(IconButton,Icons.bookmark));

    await tester.pumpAndSettle();
    expect(pageController.page, 1);

  });
}