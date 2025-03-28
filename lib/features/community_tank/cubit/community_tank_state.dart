part of 'community_tank_cubit.dart';

class CommunityTankState {
  final List<CTPost> posts;
  CommunityTankState({this.posts = const []});

  CommunityTankState copyWith({List<CTPost>? posts}) {
    return CommunityTankState(posts: posts ?? this.posts);
  }
}
