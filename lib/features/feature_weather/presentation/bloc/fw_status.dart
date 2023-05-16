
import 'package:equatable/equatable.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/domain/entities/forecase_days_entity.dart';

abstract class FwStatus extends Equatable{}
// loading state
class FwLoading extends FwStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
// loaded state
class FwCompleted extends FwStatus{

  final ForecastDaysEntity forecastDaysEntity ;

  FwCompleted(this.forecastDaysEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [forecastDaysEntity];
}

class FwError extends FwStatus{
  final String message;

  FwError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}