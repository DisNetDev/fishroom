import 'package:fishroom/core/usecases/log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/database_tables.dart';
import '../../../core/repositories/supabase_repository.dart';
import '../models/ct_post.dart';

part 'community_tank_state.dart';

class CommunityTankCubit extends Cubit<CommunityTankState> {
  CommunityTankCubit({required this.supabaseRepository})
      : super(CommunityTankState());

  final SupabaseRepository supabaseRepository;

  Future<void> createPost(CTPost post) async {
    try {
      await supabaseRepository.insert(
          tableName: SupabaseTable.communityTankPost.tableName,
          json: post.toJson());
      emit(state.copyWith(posts: [post, ...state.posts]));
    } catch (e) {
      rethrow;
    }
  }

  void clearPosts() {
    emit(state.copyWith(posts: []));
  }

  Future<void> getPosts({bool initial = false}) async {
    List<CTPost> newPosts = [];

    try {
      final response = await supabaseRepository.fetchAll(
          tableName: SupabaseTable.communityTankPost.tableName,
          limit: 50,
          offset: initial ? 0 : state.posts.length);

      if (response != null) {
        newPosts = response.map((e) => CTPost.fromJson(e)).toList();
      }
      if (initial) {
        emit(state.copyWith(posts: newPosts));
      } else {
        List<String> postIdsToRemove = [];
        for (CTPost post in newPosts) {
          if (state.posts.any((element) => element.id == post.id)) {
            postIdsToRemove.add(post.id);
          }
        }
        newPosts.removeWhere((element) => postIdsToRemove.contains(element.id));
        emit(state.copyWith(posts: [...state.posts, ...newPosts]));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> upvotePost(String postId) async {
    try {
      fishLog("Upvoting post: $postId");
      final response = await supabaseRepository.runFunction("upvote_post", {
        "post_id_param": postId,
      });
      fishLog("Response: $response");
      emit(state.copyWith(
          posts: state.posts
              .map((e) =>
                  e.id == postId ? e.copyWith(upVotes: e.upVotes + 1) : e)
              .toList()));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downvotePost(String postId) async {
    try {
      fishLog("Downvoting post: $postId");
      await supabaseRepository.runFunction("downvote_post", {
        "post_id_param": postId,
      });
      emit(state.copyWith(
          posts: state.posts
              .map((e) =>
                  e.id == postId ? e.copyWith(downVotes: e.downVotes + 1) : e)
              .toList()));
    } catch (e) {
      rethrow;
    }
  }
}
