import 'package:dio/dio.dart';
import '../model/location_model.dart';

class LocationRepository {
  final Dio _dio;

  // Using Open-Meteo Geocoding API (Free for non-commercial use, generous limits)
  static const String _baseUrl = 'https://geocoding-api.open-meteo.com/v1';

  LocationRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<LocationModel>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await _dio.get(
        '$_baseUrl/search',
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
      // In a real app, handle error properly (log it, etc.)
      return [];
    }
  }
}
