import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher_string.dart';

final dio = Dio();

String getTrickBDRoute(String path) {
  final path0 = path.replaceFirst("/", "");
  return "https://trickbd.com/$path0/?theme_change=mobile";
}

String getTrickBDHomePage() => "https://trickbd.com/?theme_change=mobile";

String get forcedMobileThemeQuery => "/?theme_change=mobile";

Future<void> launchUrlInBrowser(String? url) async {
  try {
    await launchUrlString(url ?? "", mode: LaunchMode.externalApplication);
  } catch (_) {}
}
