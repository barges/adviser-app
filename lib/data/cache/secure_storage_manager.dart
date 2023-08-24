abstract class SecureStorageManager {
  Future<void> saveDeviceId(String deviceId);
  Future<String?> getDeviceId();
}
