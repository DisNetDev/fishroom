import 'package:fishroom/core/usecases/log.dart';
import 'package:fishroom/main.dart';
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
      //i have no idea how this works but it does. Dont touch it.
      final response = await supabase
          .from(SupabaseTable.communityTankPost.tableName)
          .select('''
            *,
            upvotes:votes!inner(count),
            downvotes:votes!inner(count),
            user_vote:votes!inner(vote_type)
          ''')
          .eq('upvotes.vote_type', 'upvote')
          .eq('downvotes.vote_type', 'downvote')
          .eq('user_vote.user_id', supabaseRepository.user?.id ?? '')
          .order('created_at', ascending: false)
          .range(initial ? 0 : state.posts.length, 50);

      for (var postData in response) {
        // Create post with voting status
        final post = CTPost.fromJson(postData);
        final userVotes =
            List<Map<String, dynamic>>.from(postData['user_vote']);
        final isUpvoted =
            userVotes.isNotEmpty ? userVotes[0]['vote_type'] == 'upvote' : null;

        newPosts.add(post.copyWith(
            isUpvoted: isUpvoted,
            upVotes: postData['upvotes'][0]['count'] ?? 0,
            downVotes: postData['downvotes'][0]['count'] ?? 0));
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
