import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/navigation/page/feed/models/feed_post_model.dart';

part 'post_detail_state.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  PostDetailCubit()
    : super(
        PostDetailState(
          post: FeedPostModel(
            id: '1',
            ownerId: '',
            ownerName: 'Jennifer Coppen',
            ownerAvatar: 'https://i.pravatar.cc/150?img=1',
            postImageUrl: 'https://picsum.photos/400/600?random=1',
            description: '',
            likeCount: 2515,
            commentCount: 21,
            shareCount: 351,
            createdAt: DateTime.now().subtract(Duration(hours: 1)),
          ),
          isBookmarked: false,
        ),
      );

  void toggleBookmark() {
    emit(state.copyWith(isBookmarked: !state.isBookmarked));
  }

  void updatePost(FeedPostModel post) {
    emit(state.copyWith(post: post));
  }
}
