import '../../data/models/current_city_model.dart';
import 'package:equatable/equatable.dart';

class CurrentCityEntity extends Equatable {
  Coord? coord;
  List<Weather>? weather;
  String? base;
  Main? main;
  num? visibility;
  Wind? wind;
  Rain? rain;
  Clouds? clouds;
  num? dt;
  Sys? sys;
  num? timezone;
  num? id;
  String? name;
  num? cod;

  CurrentCityEntity(
      {this.coord,
      this.weather,
      this.base,
      this.main,
      this.visibility,
      this.wind,
      this.rain,
      this.clouds,
      this.dt,
      this.sys,
      this.timezone,
      this.id,
      this.name,
      this.cod});

  @override
  List<Object?> get props => [
    coord,
    weather,
    base,
    main,
    visibility,
    wind,
    rain,
    clouds,
    dt,
    sys,
    timezone,
    id,
    name,
    cod
  ];
}
