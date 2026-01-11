import '../model/location_model.dart';

abstract class LocationRepository {
  Future<List<LocationModel>> searchCities(String query);
}