import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../feature/main/navigation/cubit/navigation_cubit.dart';
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

  // Stream listener'ın sadece bir kez eklenmesini garanti et
  StreamSubscription<Uri>? _streamSubscription;

  // Son işlenen URI — aynı linkin tekrar işlenmesini engelle
  Uri? _lastHandledUri;

  /// Sadece initial link'i yakalar ve saklar.
  /// Stream listener'ı da başlatır (uygulama açıkken gelen linkler için).
  Future<void> initialize() async {
    print("DeepLinkService initialized");

    // Uygulama kapalıyken açılan link — sadece sakla, navigate etme
    final uri = await _appLinks.getInitialLink();
    if (uri != null) {
      print("DEEPLINK INITIAL FULL URI :> ${uri.toString()}");
      print("DEEPLINK INITIAL PATH :> ${uri.path}");
      print("DEEPLINK INITIAL SEGMENTS :> ${uri.pathSegments}");
      // Aynı initial link daha önce işlendiyse tekrar kaydetme (hot restart durumu)
      if (_lastHandledUri == null ||
          uri.toString() != _lastHandledUri.toString()) {
        _pendingDeepLink = uri;
      } else {
        print("DEEPLINK INITIAL :> stale link, skipping");
      }
    }

    // Önceki stream listener'ı iptal et ve yenisini ekle
    await _streamSubscription?.cancel();
    _streamSubscription = _appLinks.uriLinkStream.listen((uri) {
      print("DEEPLINK STREAM FULL URI :> ${uri.toString()}");
      print("DEEPLINK STREAM PATH :> ${uri.path}");
      print("DEEPLINK STREAM SEGMENTS :> ${uri.pathSegments}");
      // Aynı URI tekrar gelirse (initial link duplicate) işleme
      if (_lastHandledUri != null &&
          uri.toString() == _lastHandledUri.toString()) {
        print("DEEPLINK STREAM :> duplicate, skipping");
        return;
      }
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
    final String fullUri = uri.toString();
    final String path = uri.path;
    final segments = uri.pathSegments;
    print("DEEPLINK HANDLE :> fullUri=$fullUri");
    print("DEEPLINK HANDLE :> path=$path, segments=$segments");

    // Son işlenen URI'yi kaydet
    _lastHandledUri = uri;

    // /profile/{userId} — pathSegments: ['profile', '{userId}']
    // Önce profile kontrol et (daha spesifik)
    if (segments.length >= 2 && segments[segments.length - 2] == 'profile') {
      final String userId = segments.last;
      print("DEEPLINK -> PROFILE userId=$userId");
      if (userId.isNotEmpty) {
        final currentUserId =
            Supabase.instance.client.auth.currentUser?.id ?? '';

        if (userId == currentUserId) {
          print("DEEPLINK -> OWN PROFILE (tab 3)");
          router.go(RouteConstants.NAVIGATION);
          Future.microtask(() {
            final context = router.routerDelegate.navigatorKey.currentContext;
            if (context != null) {
              context.read<NavigationCubit>().route(3);
            }
          });
        } else {
          print("DEEPLINK -> OTHER USER userId=$userId");
          router.go(RouteConstants.NAVIGATION);
          router.push(RouteConstants.USER, extra: userId);
        }
        return true;
      }
    }

    // /post/{postId} — pathSegments: ['post', '{postId}']
    if (segments.length >= 2 && segments[segments.length - 2] == 'post') {
      final String postId = segments.last;
      print("DEEPLINK -> POST_DETAIL postId=$postId");
      router.go(RouteConstants.NAVIGATION);
      router.push(
        RouteConstants.POST_DETAIL,
        extra: {'postId': postId, 'isDraft': false},
      );
      return true;
    }

    print("DEEPLINK -> NO MATCH for path=$path");
    return false;
  }
}
