import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  /// Demande la permission des notifications.
  /// Sur iOS, permission_handler peut retourner [denied] au premier appel
  /// alors que l'utilisateur a cliqué "Allow" (bug connu). On refait une
  /// seconde tentative dans ce cas.
  Future<bool> requestNotifications() async {
    var status = await Permission.notification.request();
    if (!status.isGranted && (status.isDenied || status.isPermanentlyDenied)) {
      // Workaround iOS : second appel si le premier retourne un faux négatif
      status = await Permission.notification.request();
    }
    return status.isGranted;
  }

  /// Demande la permission de localisation (whenInUse).
  /// Retourne true si accordée (whileInUse ou always).
  Future<bool> requestLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestPhotos() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }
}
