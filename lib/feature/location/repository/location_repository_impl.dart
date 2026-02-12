import 'package:dio/dio.dart';
import '../../../core/constants/api.dart';
import '../model/location_model.dart';
import 'location_repository.dart';

class LocationRepositoryImpl extends LocationRepository {
  final Dio _dio;
  LocationRepositoryImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<List<LocationModel>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await _dio.get(
        ApiConstants.LOCATION,
        queryParameters: {
          'name': query,
          'count': 10,
          'language': 'en',
          'format': 'json',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['results'] != null) {
          final results = data['results'] as List;
          return results.map((json) => LocationModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
