import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:invoify/core/helpers/notification_router.dart';

class DeepLinkService {
  DeepLinkService({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> init() async {
    try {
      // Handle initial link when app launched via deep link
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLinkUri(initialUri);
      }

      // Listen to incoming links while app is open/backgrounded
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (uri) {
          _handleDeepLinkUri(uri);
        },
        onError: (err) {
          debugPrint('DeepLinkService stream error: $err');
        },
      );
    } catch (e) {
      debugPrint('Error initializing DeepLinkService: $e');
    }
  }

  void _handleDeepLinkUri(Uri uri) {
    debugPrint('Received Deep Link URI: $uri');

    String? invoiceId;

    // Check query params: e.g. invoify://invoice?id=XYZ or https://.../invoice?id=XYZ
    if (uri.queryParameters.containsKey('id')) {
      invoiceId = uri.queryParameters['id'];
    } else if (uri.queryParameters.containsKey('invoiceId')) {
      invoiceId = uri.queryParameters['invoiceId'];
    } else if (uri.pathSegments.isNotEmpty) {
      // Check path segments: e.g. invoify://invoice/XYZ or https://.../invoice/XYZ
      final index = uri.pathSegments.indexOf('invoice');
      if (index != -1 && index + 1 < uri.pathSegments.length) {
        invoiceId = uri.pathSegments[index + 1];
      } else if (uri.pathSegments.length == 1) {
        invoiceId = uri.pathSegments.first;
      }
    }

    if (invoiceId != null && invoiceId.isNotEmpty) {
      NotificationRouter.handleInvoiceNavigation(invoiceId);
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
