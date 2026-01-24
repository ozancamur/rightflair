part of 'post_detail_cubit.dart';

class PostDetailState extends Equatable {
  final PostModel post;

  const PostDetailState({required this.post});

  PostDetailState copyWith({PostModel? post}) {
    return PostDetailState(post: post ?? this.post);
  }

  @override
  List<Object> get props => [post];
}
