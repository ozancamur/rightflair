import 'package:app_links/app_links.dart';

class DeepLinkService {
  final _appLinks = AppLinks();

  void initialize() {
    print("DeepLinkService initialized");
    // Uygulama kapalıyken açılan link
    _appLinks.getInitialLink().then((uri) {
      print("DEEPLINK OFF :> ${uri?.path}");
    });

    // Uygulama açıkken gelen link
    _appLinks.uriLinkStream.listen((uri) {
      print("DEEPLINK ON :> ${uri.path}");
    });
  }
}
