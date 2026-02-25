import 'package:app_links/app_links.dart';
import 'package:rightflair/core/constants/route.dart';

import '../utils/router.dart';

class DeepLinkService {
  // Singleton
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();

  // Uygulama kapalıyken gelen pending deep link bilgisi
  Uri? _pendingDeepLink;
  Uri? get pendingDeepLink => _pendingDeepLink;

  /// Sadece initial link'i yakalar ve saklar.
  /// Stream listener'ı da başlatır (uygulama açıkken gelen linkler için).
  Future<void> initialize() async {
    print("DeepLinkService initialized");

    // Uygulama kapalıyken açılan link — sadece sakla, navigate etme
    final uri = await _appLinks.getInitialLink();
    if (uri != null) {
      print("DEEPLINK INITIAL :> ${uri.path}");
      _pendingDeepLink = uri;
    }

    // Uygulama açıkken gelen link — direkt navigate et
    _appLinks.uriLinkStream.listen((uri) {
      print("DEEPLINK STREAM :> ${uri.path}");
      _handleDeepLink(uri);
    });
  }

  /// Pending deep link varsa işler ve temizler.
  /// Splash sonrası çağrılmalı. true dönerse navigate splash'te yapılmaz.
  bool handlePendingDeepLink() {
    final uri = _pendingDeepLink;
    if (uri == null) return false;
    _pendingDeepLink = null;
    return _handleDeepLink(uri);
  }

  /// Deep link URI'sını parse edip ilgili sayfaya yönlendirir.
  bool _handleDeepLink(Uri uri) {
    final String path = uri.path;
    final String id = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    print("DEEPLINK HANDLE :> path=$path, id=$id");

    if (path.contains('/post/') && id.isNotEmpty) {
      print("DEEPLINK -> POST_DETAIL postId=$id");
      router.go(RouteConstants.NAVIGATION);
      router.push(
        RouteConstants.POST_DETAIL,
        extra: {'postId': id, 'isDraft': false},
      );
      return true;
    } else if (path.contains('/profile/')) {
      final String userId = path.split('/profile/').last;
      print("DEEPLINK -> USER userId=$userId");
      if (userId.isNotEmpty) {
        router.go(RouteConstants.NAVIGATION);
        router.push(RouteConstants.USER, extra: userId);
        return true;
      }
    }
    return false;
  }
}
