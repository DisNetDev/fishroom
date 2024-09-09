import 'package:bloc/bloc.dart';
import '../../../core/models/tank.dart';

part 'tanks_state.dart';

class TanksCubit extends Cubit<TanksState> {
  TanksCubit() : super(const TanksState(tanks: []));

  void addTank(Tank tank) {
    emit(TanksState(tanks: [...state.tanks, tank]));
  }
}
