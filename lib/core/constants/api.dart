class ApiConstants {
  const ApiConstants._();

  static const String LOCATION =
      'https://geocoding-api.open-meteo.com/v1/search';

  static String MUSIC({required String query}) =>
      'https://api.deezer.com/search?q=$query';
}
