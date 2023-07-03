part of "bird_post_cubit.dart";

enum BirdPostStatus { initial, error, loading, loaded, postAdded, postRemoved }

class BirdPostState extends Equatable {
  final List<BirdModel> birdPosts;
  final BirdPostStatus status;

  const BirdPostState({required this.birdPosts, required this.status});

  @override
  List<Object> get props => [birdPosts, status];

  BirdPostState copyWith({List<BirdModel>? birdPost, BirdPostStatus? status,}){
    return BirdPostState(birdPosts: birdPost ?? this.birdPosts,
    status: status ?? this.status);
  }
}