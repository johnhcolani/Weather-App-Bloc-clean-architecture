
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app_clean_bloc/features/feature_weather/data/data_source/remote/api_provider.dart';

@immutable
abstract class UnitStatus extends Equatable {}

/// loading state
class UnitLoading extends UnitStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

/// loaded state
class UnitCompleted extends UnitStatus{
  final ApiProvider apiProvider;

  UnitCompleted(this.apiProvider);

  @override
  // TODO: implement props
  List<Object?> get props => [apiProvider];
}

/// error state
class UnitError extends UnitStatus{
  final String? message;
  UnitError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}