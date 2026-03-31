import 'dart:io';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class FirebaseMlService {
  Future<File> loadModel() async{
    final instance = FirebaseModelDownloader.instance;
    final model = await instance.getModel("aiy-model", FirebaseModelDownloadType.localModel, FirebaseModelDownloadConditions(
      iosAllowsBackgroundDownloading: false,
      iosAllowsCellularAccess: true,
      androidChargingRequired: false,  // Allow download without charging
      androidDeviceIdleRequired: false,  // Allow download when device is active
      androidWifiRequired: false  // Allow download over cellular
    ));
    return model.file;
  }
}