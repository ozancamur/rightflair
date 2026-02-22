import '../../../core/constants/enums/report_reason.dart';
import '../../main/profile/model/pagination.dart';
import '../model/search_response.dart';
import '../model/share.dart';

abstract class ShareRepository {
  Future<SearchReponseModel?> searchUsers({
    required String query,
    required PaginationModel pagination,
  });

  Future<void> reportPost({required String pId, required ReportReason reason});

  Future<void> reportUser({
    required String reportedId,
    required ReportReason reason,
    String? description,
  });

  Future<bool> shareProfile({
    required String recipientId,
    required String referencedUserId,
  });

  Future<bool> sharePost({
    required String recipientId,
    required String referencedPostId,
    String? content,
  });

  Future<List<SearchUserModel>?> getShareSuggestions();
}
