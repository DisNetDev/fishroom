import 'package:fishroom/core/repositories/supabase_repository.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/database_tables.dart';
import '../../../core/models/tank.dart';

part 'tanks_state.dart';

class TanksCubit extends Cubit<TanksState> {
  TanksCubit({required this.supabaseRepository})
      : super(const TanksState(tanks: [], error: false));

  final SupabaseRepository supabaseRepository;

  Future<void> addTank(Tank tank) async {
    fishLog("Creating a tank...");
    await supabaseRepository.insert(
        tableName: Table.tanks.label, json: tank.toJson());

    emit(state.copyWith(tanks: [...state.tanks, tank]));
  }

  Future<void> getTanks() async {
    fishLog("Getting tanks...");
    final data = await supabaseRepository.fetch(
        tableName: Table.tanks.label,
        column: "owner_id",
        condition: supabaseRepository.user!.id);
    fishLog(data.toString());

    if (data != null) {
      List<Tank> tanks = [];
      for (Map<String, dynamic> tankJson in data) {
        tanks.add(Tank.fromJson(tankJson));
        emit(state.copyWith(tanks: tanks));
      }
    } else {
      emit(state.copyWith(error: true));
    }
  }

  void clear() {
    emit(const TanksState(tanks: [], error: false));
  }
}
