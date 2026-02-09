import '../model/request_search.dart';
import '../model/response_search.dart';

abstract class SearchRepository {
  Future<ResponseSearchModel?> searchPosts({required RequestSearchModel body});
}
