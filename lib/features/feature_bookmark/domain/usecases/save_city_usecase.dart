import 'package:weather_app_clean_bloc/core/resources/data_state.dart';
import 'package:weather_app_clean_bloc/core/usecase/use_case.dart';
import 'package:weather_app_clean_bloc/features/feature_bookmark/domain/repository/city_repository.dart';

import '../entities/city_entity.dart';

class SaveCityUseCase implements UseCase<DataState<City>,String>{
  final CityRepository _cityRepository;

  SaveCityUseCase(this._cityRepository);

  @override
  Future<DataState<City>> call(String params) {
    return _cityRepository.saveCityToDB(params);
  }
}