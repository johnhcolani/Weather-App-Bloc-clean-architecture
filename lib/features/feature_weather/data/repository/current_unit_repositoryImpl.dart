import 'package:weather_app_clean_bloc/core/resources/data_state.dart';

import 'package:weather_app_clean_bloc/features/feature_weather/domain/entities/current_unit_entity.dart';

import '../../domain/repository/current_unit_repository.dart';
import '../data_source/remote/api_provider.dart';

class UnitRepositoryImpl extends UnitRepository {
  ApiProvider apiProvider;

  UnitRepositoryImpl(this.apiProvider);

  @override
  String FetchUnitData(String unit) {
    return apiProvider.unit = 'imperial';
  }

  @override
  Future<DataState<CurrentUnitEntity>> fetchUnitData(String unit) {
    // TODO: implement fetchUnitData
    throw UnimplementedError();
  }

//@override
// Future<DataState<CurrentUnitEntity>> fetchUnitData(String unit)async {
//   apiProvider.unit='imperial';
//   try{
//var unitData = await apiProvider.fetchUnitData(unit);
//var dataState = DataState<CurrentUnitEntity>.(unitData);
//return dataState;
//   }catch(e){
//     var dataState = DataState<CurrentUnitEntity>.e(e.toString());
//     return dataState;
//   }
// }
}