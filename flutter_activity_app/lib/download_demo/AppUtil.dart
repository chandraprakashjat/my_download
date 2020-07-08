import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class AppUtil{


  static Future<String> findLocalPath(TargetPlatform platform, String folderName) async
 {

    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();


    final Directory _appDocDirFolder =  Directory('${directory.path}/$folderName/');

    if(await _appDocDirFolder.exists())
    { //if folder already exists return path
      return _appDocDirFolder.path;
    }
    else
      {//if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder=await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }

  }



}