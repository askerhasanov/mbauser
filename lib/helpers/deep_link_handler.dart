import 'package:flutter/material.dart';
import 'package:mbauser/globalVariables.dart';
import 'package:mbauser/helpers/payment_pages.dart';
import 'package:mbauser/pages/views/myCoursePage.dart';

class DeepLinkHandler {
  final GlobalKey<NavigatorState> navigatorKey;

  DeepLinkHandler(this.navigatorKey);

  void handleDeepLink(Uri uri) {
    debugPrint('Deep link received: $uri');

    if (uri.scheme == 'mbauser' && uri.host == 'payment') {
      final path = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
      switch (path) {
        case 'success':
          _navigateToSuccessPage(uri.queryParameters['transactionId']);
          break;
        case 'cancel':
          _navigateToCancelPage();
          break;
        case 'error':
          _navigateToErrorPage();
          break;
        default:
          debugPrint('Unknown deep link path: $path');
      }
    }
  }

  void _navigateToSuccessPage(String? transactionId) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => PaymentSuccessPage(transactionId: transactionId),
      ),
    );
  }

  void _navigateToCancelPage() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => PaymentCancelPage(),
      ),
    );
  }

  void _navigateToErrorPage() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => PaymentErrorPage(),
      ),
    );
  }
}
