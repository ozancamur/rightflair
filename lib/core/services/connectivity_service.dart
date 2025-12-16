import 'package:connectivity_plus/connectivity_plus.dart';

/// İnternet bağlantısını kontrol eden servis
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// İnternet bağlantısı var mı kontrolü
  /// Returns: true ise internet var, false ise yok
  Future<bool> hasInternetConnection() async {
    try {
      final ConnectivityResult connectivityResult = await _connectivity
          .checkConnectivity();

      // Bağlantı yok mu kontrol et
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Mobil veri, WiFi veya Ethernet bağlantısı var
      return connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet;
    } catch (e) {
      // Hata durumunda false döndür
      return false;
    }
  }

  /// Bağlantı değişikliklerini dinle
  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
