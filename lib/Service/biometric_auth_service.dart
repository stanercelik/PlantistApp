import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricAuthService {
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<bool> authenticate() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        Get.snackbar("Error", "Cannot check biometrics",
            snackPosition: SnackPosition.TOP);
        return false;
      }

      bool isBiometricSupported = await auth.isDeviceSupported();
      if (!isBiometricSupported) {
        Get.snackbar(
            "Error", "Biometric authentication is not supported on this device",
            snackPosition: SnackPosition.TOP);
        return false;
      }

      bool hasBiometrics = await auth
          .getAvailableBiometrics()
          .then((biometrics) => biometrics.isNotEmpty);
      if (!hasBiometrics) {
        Get.snackbar("Error", "No biometrics enrolled",
            snackPosition: SnackPosition.TOP);
        return false;
      }

      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Bu özelliğe erişmek için kimliğinizi doğrulayın',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (!isAuthenticated) {
        Get.snackbar("Error", "Authentication failed'",
            snackPosition: SnackPosition.TOP);
      }

      return isAuthenticated;
    } catch (e) {
      Get.snackbar("Error", "Error during authentication",
          snackPosition: SnackPosition.TOP);
      return false;
    }
  }

  Future<void> storeCredentials(String email, String password) async {
    try {
      await secureStorage.write(key: 'email', value: email);
      await secureStorage.write(key: 'password', value: password);
    } catch (e) {
      Get.snackbar("Error", "Error storing credentials",
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<Map<String, String?>> getStoredCredentials() async {
    try {
      String? email = await secureStorage.read(key: 'email');
      String? password = await secureStorage.read(key: 'password');
      return {'email': email, 'password': password};
    } catch (e) {
      Get.snackbar("Error", "Error retrieving credentials",
          snackPosition: SnackPosition.TOP);
      return {'email': null, 'password': null};
    }
  }

  Future<void> clearCredentials() async {
    try {
      await secureStorage.delete(key: 'email');
      await secureStorage.delete(key: 'password');
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error clearing credentials",
      );
    }
  }
}
