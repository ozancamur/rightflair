import '../../main/profile/model/pagination.dart';
import '../../share/model/search_response.dart';

abstract class SearchRepository {
  Future<SearchReponseModel?> searchUsers({
    required String query,
    required PaginationModel pagination,
  });
}
