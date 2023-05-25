
import 'package:weather_app_clean_bloc/core/resources/data_state.dart';
import 'package:weather_app_clean_bloc/core/usecase/use_case.dart';
import 'package:weather_app_clean_bloc/features/feature_bookmark/domain/repository/city_repository.dart';

import '../entities/city_entity.dart';

class GetCityUseCase implements UseCase<DataState<City?>, String>{
  final CityRepository _cityRepository;

  GetCityUseCase(this._cityRepository);

  @override
  Future<DataState<City?>> call(String params) {
    return _cityRepository.findCityByName(params);
  }

}