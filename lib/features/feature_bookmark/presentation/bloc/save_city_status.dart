import 'package:equatable/equatable.dart';

import '../../domain/entities/city_entity.dart';

abstract class SaveCityStatus extends Equatable{}

class SaveCityInitial extends SaveCityStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
// loading status
class SaveCityLoading extends SaveCityStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
// loaded status
class SaveCityCompleted extends SaveCityStatus{
  final City city;

  SaveCityCompleted(this.city);

  @override
  // TODO: implement props
  List<Object?> get props => [city];

}
// error status
class SaveCityError extends SaveCityStatus{
  final String? message;

  SaveCityError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}