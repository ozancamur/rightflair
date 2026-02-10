part of 'post_detail_cubit.dart';

class PostDetailState extends Equatable {
  final PostModel post;
  final bool isLoading;
  const PostDetailState({required this.post, required this.isLoading});

  PostDetailState copyWith({PostModel? post, bool? isLoading}) {
    return PostDetailState(
      post: post ?? this.post,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [post, isLoading];
}
