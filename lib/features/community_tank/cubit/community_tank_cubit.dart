import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/database_tables.dart';
import '../../../core/repositories/supabase_repository.dart';
import '../models/ct_post.dart';

part 'community_tank_state.dart';

class CommunityTankCubit extends Cubit<CommunityTankState> {
  CommunityTankCubit(this._supabaseRepository) : super(CommunityTankState());

  final SupabaseRepository _supabaseRepository;

  Future<void> createPost(CTPost post) async {
    try {
      await _supabaseRepository.insert(
          tableName: SupabaseTable.communityTankPost.tableName,
          json: post.toJson());
    } catch (e) {
      rethrow;
    }
  }

  void clearPosts() {
    emit(state.copyWith(posts: []));
  }

  Future<void> getPosts() async {
    List<CTPost> newPosts = [];

    try {
      final response = await _supabaseRepository.fetch(
          tableName: SupabaseTable.communityTankPost.tableName,
          conditionalColumn: SupabaseTable.communityTankPost.createdAt,
          condition: 'DESC',
          limit: 20,
          offset: state.posts.length);

      if (response != null) {
        newPosts = response.map((e) => CTPost.fromJson(e)).toList();
        for (CTPost post in newPosts) {
          if (!state.posts.any((element) => element.id == post.id)) {
            state.posts.add(post);
          }
        }
      }

      emit(state);
    } catch (e) {
      rethrow;
    }
  }
}
