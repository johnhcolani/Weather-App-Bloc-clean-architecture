import '../../../../core/resources/data_state.dart';
import '../entities/current_city_entity.dart';
import '../entities/current_unit_entity.dart';

abstract class UnitRepository{

  Future<DataState<CurrentUnitEntity>> fetchUnitData(String unit);

}