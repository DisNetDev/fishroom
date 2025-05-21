import 'dart:io';

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
        tableName: SupabaseTable.fish.tableName,
      );

      if (response != null) {
        fishLog(response);
        inhabitants = response.map((e) => Inhabitant.fromJson(e)).toList();
      }

      final responseUnlisted = await _supabaseRepository.fetch(
          tableName: "fish_custom",
          conditionalColumn: "created_by",
          condition: _supabaseRepository.user!.id);

      if (responseUnlisted != null) {
        inhabitants.addAll(responseUnlisted.map((e) => Inhabitant.fromJson(e)));
      }
      return inhabitants;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createInhabitant(Inhabitant inhabitant, File? image) async {
    try {
      if (image != null) {
        final String? imageUrl = await _supabaseRepository.uploadImage(
          image,
          path: "fish",
          folderName: inhabitant.id,
        );
        inhabitant.imageUrl = imageUrl;
      }

      await _supabaseRepository.insert(
          tableName: "fish_custom",
          json: inhabitant.toJsonUnlisted()
            ..addAll({'created_by': _supabaseRepository.user!.id}));
    } catch (e) {
      rethrow;
    }
  }
}
