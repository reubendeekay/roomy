

import 'package:in_app_update/in_app_update.dart';

Future<void> checkForUpdate() async {
  InAppUpdate.checkForUpdate().then((info) {
    if (info.updateAvailability == UpdateAvailability.updateAvailable)
      InAppUpdate.startFlexibleUpdate().then((_) {}).catchError((e) {});
  });
}