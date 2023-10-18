import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'secure_storage_manager.dart';

@Singleton(as: SecureStorageManager)
class SecureStorageManagerImpl implements SecureStorageManager {
  static const String _uuidKey = 'com.questico.fortunica.readerapp.uuidKey';
  final FlutterSecureStorage _secureStore = const FlutterSecureStorage();

  @override
  Future<String?> getDeviceId() async {
    String? deviceId;
    try {
      deviceId = await _secureStore.read(
        key: _uuidKey,
      );
    } catch (e) {
      _secureStore.deleteAll();
    }
    return deviceId;
  }

  @override
  Future<void> saveDeviceId(String deviceId) async {
    await _secureStore.write(
      key: _uuidKey,
      value: deviceId,
    );
  }
}
