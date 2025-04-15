import 'package:collection/collection.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:fishroom/features/community_tank/models/ct_report.dart';
import 'package:fishroom/main.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../core/models/database_tables.dart';
import '../../../core/repositories/supabase_repository.dart';
import '../models/ct_comment.dart';
import '../models/ct_post.dart';

part 'community_tank_state.dart';

class CommunityTankCubit extends HydratedCubit<CommunityTankState> {
  CommunityTankCubit({required this.supabaseRepository})
      : super(CommunityTankState(posts: [], hiddenPostsIds: []));

  final SupabaseRepository supabaseRepository;

  @override
  CommunityTankState? fromJson(Map<String, dynamic> json) {
    return CommunityTankState(
        posts: [], hiddenPostsIds: json["hiddenPostsIds"]);
  }

  @override
  Map<String, dynamic>? toJson(CommunityTankState state) {
    return {"hiddenPostsIds": state.hiddenPostsIds};
  }

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
      final response = await supabase
          .from(SupabaseTable.communityTankPost.tableName)
          .select('''
            *,
            upvotes:votes(count),
            downvotes:votes(count),
            user_vote:votes(vote_type),
            comment_count:community_tank_posts_comments(count)
          ''')
          .eq('upvotes.vote_type', 'upvote')
          .eq('downvotes.vote_type', 'downvote')
          .eq('user_vote.user_id', supabaseRepository.user?.id ?? '')
          .not('id', 'in', state.hiddenPostsIds)
          .order('created_at', ascending: false)
          .range(initial ? 0 : state.posts.length, 50);

      for (var postData in response) {
        // Create post with voting status
        final post = CTPost.fromJson(postData);
        final userVotes =
            List<Map<String, dynamic>>.from(postData['user_vote'] ?? []);
        final isUpvoted =
            userVotes.isNotEmpty ? userVotes[0]['vote_type'] == 'upvote' : null;

        newPosts.add(post.copyWith(
            isUpvoted: isUpvoted,
            upVotes: postData['upvotes']?.isNotEmpty == true
                ? postData['upvotes'][0]['count'] ?? 0
                : 0,
            downVotes: postData['downvotes']?.isNotEmpty == true
                ? postData['downvotes'][0]['count'] ?? 0
                : 0,
            commentCount: postData['comment_count']?.isNotEmpty == true
                ? postData['comment_count'][0]['count'] ?? 0
                : 0));
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
    CommunityTankState oldState = state.copyWith();
    bool? isAlreadyUpVoted =
        state.posts.firstWhereOrNull((test) => test.id == postId)?.isUpvoted;
    if (isAlreadyUpVoted == true) return;
    emit(state.copyWith(
        posts: state.posts
            .map((e) => e.id == postId
                ? e.copyWith(
                    upVotes: e.upVotes + 1,
                    downVotes:
                        e.isUpvoted == false ? e.downVotes - 1 : e.downVotes,
                    isUpvoted: true)
                : e)
            .toList()));
    try {
      fishLog("Upvoting post: $postId");
      await supabaseRepository.runFunction("upvote_post", {
        "post_id_param": postId,
      });
    } catch (e) {
      emit(oldState);

      rethrow;
    }
  }

  Future<void> downvotePost(String postId) async {
    CommunityTankState oldState = state.copyWith();
    bool? isAlreadyDownVoted =
        state.posts.firstWhereOrNull((test) => test.id == postId)?.isUpvoted;
    if (isAlreadyDownVoted == false) return;
    emit(state.copyWith(
        posts: state.posts
            .map((e) => e.id == postId
                ? e.copyWith(
                    upVotes: e.isUpvoted == true ? e.upVotes - 1 : e.upVotes,
                    downVotes: e.downVotes + 1,
                    isUpvoted: false)
                : e)
            .toList()));
    try {
      fishLog("Downvoting post: $postId");
      await supabaseRepository.runFunction("downvote_post", {
        "post_id_param": postId,
      });
    } catch (e) {
      emit(oldState);
      rethrow;
    }
  }

  Future<List<CTComment>> getComments(String postId) async {
    try {
      final response = await supabase
          .from(SupabaseTable.communityTankPostComments.tableName)
          .select('*')
          .eq('post_id', postId)
          .not('id', 'in', state.hiddenPostsIds);

      return response.map((e) => CTComment.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createComment(String postId, CTComment comment) async {
    try {
      await supabaseRepository.insert(
          tableName: SupabaseTable.communityTankPostComments.tableName,
          json: comment.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await supabaseRepository.delete(
          tableName: SupabaseTable.communityTankPost.tableName,
          column: SupabaseTable.communityTankPost.id,
          condition: postId);

      emit(state.copyWith(
          posts: state.posts.where((test) => test.id != postId).toList()));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> report(CTReport report) async {
    try {
      await supabaseRepository.insert(
          tableName: "community_tank_reports", json: report.toMap());
      if (report.commentId != null || report.postId != null) {
        emit(state.copyWith(hiddenPostsIds: [
          ...state.hiddenPostsIds,
          report.postId ?? report.commentId!,
        ]));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removePost(String postId) async {
    emit(state.copyWith(
        posts: state.posts.where((test) => test.id != postId).toList()));
  }
}
