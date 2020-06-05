import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class Consts {


  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
  static const String title = 'Please select your supported BioMetric scanner app for scanning.';
  static const String biometic_titile = 'Biometric Scanner';
  static const IconData fingerprint = IconData(0xe90d, fontFamily: 'MaterialIcons');
  static const String restricted = 'Your app restricted for permission ';

  static const String biometrics = 'Biometrics';
  static const String morpho = 'Morpho';
  static const String mantra = 'Mantra';
  static String download_failed='File download failed. Plese try again.';

  static String INTENT_ACTION_MORPHO= 'com.example.biometricscanner.SCANNER';
  static String MORPHO_SCANNER_PACKAGE = 'com.example.biometricscanner';

  static Future<bool>  checkAppAvailable(value)
  async {
    bool isInstalled=false;
    switch(value)
    {
//com.example.biometricscanner
    //com.androidwave.recyclerviewpagination
    case morpho:
        return isInstalled = await DeviceApps.isAppInstalled('com.example.biometricscanner');
        break;

      case mantra:
        return isInstalled = await DeviceApps.isAppInstalled('com.example.biometricscanner');
        break;
    }


  }
  
  static showAlert(BuildContext buildContext,String value)
  {

    AlertDialog alert =  AlertDialog(content: Text(value),actions: [
      
      RaisedButton(onPressed: (){Navigator.of(buildContext).pop();},child: Text('OK'),)
    ],);

    showDialog(context: buildContext, builder: (BuildContext context) {return alert;});
  }
  
  static AlertDialog showAlertForCheckAgain(Permission permission,BuildContext buildContext)
  {
    AlertDialog alert = AlertDialog(content: Text('App  need Storage permission for complete download process. So please allow to download app'),
    actions: [

      RaisedButton(onPressed: (){Navigator.of(buildContext).pop(true);},child: Text('Ok'),),
      RaisedButton(onPressed: (){Navigator.of(buildContext).pop(false);},child: Text('Cancel'),)
    ],);

    return alert;
  }
}