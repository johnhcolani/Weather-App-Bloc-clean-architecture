
import 'package:equatable/equatable.dart';

class CurrentUnitEntity extends Equatable{
  final String unit;

  const CurrentUnitEntity(this.unit);

  @override

  List<Object?> get props => [unit];


}