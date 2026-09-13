import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quill/core/constants/app_constants.dart';

class AppStorage {
  final storage = FlutterSecureStorage();
  Future<void> saveid(String id) async =>
      await storage.write(key: AppConstants.id, value: id);
  Future<void> saveAccessToken(String accessToken) async =>
      await storage.write(key: AppConstants.accessToken, value: accessToken);
  Future<void> saveRefreshToken(String refreshToken) async =>
      await storage.write(key: AppConstants.refreshToken, value: refreshToken);

  Future<String?> readid() async => await storage.read(key: AppConstants.id);
  Future<String?> readAccessToken() async =>
      await storage.read(key: AppConstants.accessToken);
  Future<String?> readRefreshToken() async =>
      await storage.read(key: AppConstants.refreshToken);
}
