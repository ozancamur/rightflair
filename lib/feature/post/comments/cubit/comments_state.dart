part of 'comments_cubit.dart';

class CommentsState extends Equatable {
  final List<CommentModel>? comments;
  final bool isLoading;
  const CommentsState({this.comments, this.isLoading = false});

  CommentsState copyWith({List<CommentModel>? comments, bool? isLoading}) {
    return CommentsState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [comments ?? [], isLoading];
}
