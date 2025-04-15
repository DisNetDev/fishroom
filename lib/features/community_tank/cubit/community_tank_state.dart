part of 'community_tank_cubit.dart';

class CommunityTankState {
  final List<CTPost> posts;
  final List<String> hiddenPostsIds;
  CommunityTankState({required this.posts, required this.hiddenPostsIds});

  CommunityTankState copyWith(
      {List<CTPost>? posts, List<String>? hiddenPostsIds}) {
    return CommunityTankState(
        posts: posts ?? this.posts,
        hiddenPostsIds: hiddenPostsIds ?? this.hiddenPostsIds);
  }
}
