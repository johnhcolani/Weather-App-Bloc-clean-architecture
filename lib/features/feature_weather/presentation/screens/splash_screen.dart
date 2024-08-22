import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/widgets/main_wrapper.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController oneSecondController;
  late Animation<Offset> movingLogoAnimation;
  Timer? _timer;

  @override
  void initState() {
    oneSecondController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    movingLogoAnimation =
        Tween(begin: const Offset(0, 0.4), end: const Offset(0, 0.6)).animate(
            oneSecondController.drive(CurveTween(curve: Curves.elasticIn)));

    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    oneSecondController.dispose();
    super.dispose();
  }
  _startDelay() {
    _timer = Timer(const Duration(seconds: 4), _goNext);
  }

  _goNext() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainWrapper()));
    // '/MyApp'; (context) => const MyApp();
  }

  @override
  Widget build(BuildContext context) {
    double he = MediaQuery.of(context).size.height;
    double wi = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.fill)),
            ),
            Positioned(
              bottom: 400,
              top: 20,
              right: 2,
              left: 2,
              child: SlideTransition(
                position: movingLogoAnimation,
                child: Center(
                  child: Image.asset(
                    "assets/images/back2.png",
                    scale: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
