import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<void> requestPermissions() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    if (android.version.sdkInt >= 33) {
      await _requestPermission(Permission.photos);
      await _requestPermission(Permission.videos);
    } else {
      await _requestPermission(Permission.storage);
    }

    await _requestPermission(Permission.notification);
  }

  static Future<void> _requestPermission(Permission permission) async {
    if (await permission.isDenied ||
        await permission.isRestricted ||
        await permission.isPermanentlyDenied) {
      final result = await permission.request();
      if (result.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }
}
