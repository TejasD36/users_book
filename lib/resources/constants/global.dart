import '../../core.dart';

class Global {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String? token;
  static String? fcmToken;
  static int? userId;
  static String? base64AppLogo;
}
