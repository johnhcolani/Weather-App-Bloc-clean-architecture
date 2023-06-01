
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/current_unit_entity.dart';
import '../repository/current_unit_repository.dart';

class GetCurrentUnitUseCase extends UseCase<DataState<CurrentUnitEntity>, String>{
  final UnitRepository unitRepository;
  GetCurrentUnitUseCase(this.unitRepository);

  @override
  Future<DataState<CurrentUnitEntity>> call(String param) {
    return unitRepository.fetchUnitData(param);
  }

}