import 'package:app_links/app_links.dart';
import 'package:rightflair/core/constants/route.dart';

import '../utils/router.dart';

class DeepLinkService {
  final _appLinks = AppLinks();

  void initialize() {
    print("DeepLinkService initialized");
    // Uygulama kapalıyken açılan link
    _appLinks.getInitialLink().then((uri) {
      print("DEEPLINK OFF :> ${uri?.path}");
      final String path = uri?.path ?? '';
      final String id = uri?.pathSegments.last ?? '';
      print("DEEPLINK OFF ID :> $id");
      if (path.contains("post")) {
        print("DEEPLINK OFF POST");
        router.push(
          RouteConstants.POST_DETAIL,
          extra: {'postId': id, 'isDraft': false},
        );
      } else if (path.contains("/profile/")) {
        print("DEEPLINK OFF PROFILE");
        final String id = path.split("/profile/").last;
      }
    });

    // Uygulama açıkken gelen link
    _appLinks.uriLinkStream.listen((uri) {
      print("DEEPLINK ON :> ${uri.path}");
      final String path = uri.path;
      final String id = uri.pathSegments.last;
      print("DEEPLINK ON ID :> $id");
      if (path.contains("post")) {
        print("DEEPLINK ON POST");
        router.push(
          RouteConstants.POST_DETAIL,
          extra: {'postId': id, 'isDraft': false},
        );
      } else if (path.contains("/profile/")) {
        print("DEEPLINK ON PROFILE");
        final String id = path.split("/profile/").last;
      }
    });
  }
}
