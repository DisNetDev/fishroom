import 'package:fishroom/core/models/database_tables.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/supabase_repository.dart';
import '../models/inhabitant.dart';

part 'inhabitants_state.dart';

class InhabitantsCubit extends Cubit<InhabitantsState> {
  InhabitantsCubit(this._supabaseRepository) : super(InhabitantsState());

  final SupabaseRepository _supabaseRepository;

  Future<List<Inhabitant>> getAllInhabitants() async {
    try {
      List<Inhabitant> inhabitants = [];
      final response = await _supabaseRepository.fetchAll(
        tableName: Table.fish.tableName,
      );

      if (response != null) {
        fishLog(response);
        inhabitants = response.map((e) => Inhabitant.fromJson(e)).toList();
      }

      return inhabitants;
    } catch (e) {
      rethrow;
    }
  }
}
