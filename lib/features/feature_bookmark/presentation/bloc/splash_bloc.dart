import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    Stream<SplashState> mapEventToState(SplashEvent event) async*{
      if(event is InitializeSplashEvent){
        await Future.delayed(Duration(seconds: 2));
        yield SplashComplete();
      }
    }
  }
}
