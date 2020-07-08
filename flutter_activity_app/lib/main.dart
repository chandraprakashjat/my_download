import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:android_intent/android_intent.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;
import 'package:intent/extra.dart' as android_extra;



import 'download_demo/AppUtil.dart';
import 'download_demo/Consts.dart';
import 'download_demo/CustomDialog.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: false);
  runApp(new MaterialApp(
    home: new CustomIconWidget(),
  ));
}

class CustomIconWidget extends StatefulWidget with WidgetsBindingObserver{
  @override
  _State createState() {
    return new _State();
  }
}

class _State extends State<CustomIconWidget> {

  BuildContext buildContext;
  TargetPlatform platform;
  ProgressDialog pr;
//https://androidwave.com/source/apk/app-pagination-recyclerview.apk
  //http://59.165.234.14:8796/owncloud/index.php/s/eMQs1k3JPGOwsvx/download
  final _apk = [{'name': 'APK File', 'link': 'http://59.165.234.14:8796/owncloud/index.php/s/eMQs1k3JPGOwsvx/download'},];

  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  String _localPath;
  ReceivePort _port = ReceivePort();
  @override
  Widget build(BuildContext context) {
    buildContext = context;
    platform = Theme.of(context).platform;

    return new Scaffold(
      appBar: AppBar(
        title: Text(Consts.biometic_titile),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black26,
                width: .5,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  new FlatButton(
                    onPressed: () {
                      onThumbClick();
                    },
                    child: new Icon(Consts.fingerprint,
                        size: 100.0, color: Colors.black87),
                  ),
                  Text(
                    Consts.biometrics,
                  )
                ],
              ),
            )),
      ),
    );
  }



  void checkForApplication(String value) async
  {

    var isAvaible = await Consts.checkAppAvailable(value);
    if(isAvaible) launchApp(value);
    else checkPermissionForDownload(value);
  }

  void onThumbClick()async
  {
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: Consts.title,
          buttonTextFirst: Consts.morpho,
          buttonTextSecond: Consts.mantra,
        ),
      ).then((value) => checkForApplication(value));
    });
  }




  void checkPermissionForDownload(value)async
  {
    Permission permission = Permission.storage;
    var status = await permission.status;
    permissionStatus(status, permission,value);

  }


  void permissionStatus(PermissionStatus permissionStatus, Permission permission, value)
  {
    switch (permissionStatus) {
      case PermissionStatus.undetermined:
        {
          callForPermission(permission,value);
          break;
        }
      case PermissionStatus.granted:
        {
          downloadApkFor(value);
          break;
        }

      case PermissionStatus.denied:
        {

          showDialog(context: buildContext, builder: (BuildContext context) {return Consts.showAlertForCheckAgain(permission,buildContext);})
              .then((value1) => {if(value1) callForPermission(permission, value)});
          break;
        }

      case PermissionStatus.restricted:
        {
          Consts.showAlert(buildContext,Consts.restricted);
          break;
        }

      case PermissionStatus.permanentlyDenied:
        {
          openAppSettings().then((value) => checkPermissionForDownload(value));
          break;
        }
    }
  }

  Future<void> callForPermission(Permission permission,String value) async {
    final status = await permission.request();
    permissionStatus(status, permission,value);
  }



  void downloadApkFor(value)
  {

    downloadCode();
  }

  void launchApp(value)
  {
    android_intent.Intent()
      ..setAction(Consts.INTENT_ACTION_MORPHO)
      ..setPackage(Consts.MORPHO_SCANNER_PACKAGE)
      ..startActivityForResult().then((value)
      {

        var listString = List<String>.from(value);
        print(listString.length);
      },onError: (e)=> {print(e.toString())});

  }

  void errorAlert(String error)
  {
    AlertDialog alertDialog= AlertDialog(content: Text(error),actions: [
      RaisedButton(child: Text('Ok'),onPressed: (){Navigator.pop(buildContext);},)
    ],);
    showDialog(context: buildContext, builder: (BuildContext context) {return alertDialog;});
  }


  //:::::::::::::::::::::::::::; Download Apk

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);



    _prepare();
  }
  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }
  void downloadCode()
  {
    showCustomDialog();
    _requestDownload(_tasks[0]);
  }
  void _bindBackgroundIsolate()
  {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      if (false) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];


      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }

      if(task.status == DownloadTaskStatus.complete)
      {
        pr.hide();
        _openDownloadedFile(task);
      }else
      if(task.status==DownloadTaskStatus.failed)
      {
        FlutterDownloader.cancel(taskId: id);
        await pr.hide();
        Consts.showAlert(buildContext,Consts.download_failed);
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress)
  {
    if (true) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        fileName: 'test.jpg',
        showNotification: true,
        openFileFromNotification: true);
  }


  Future<bool> _openDownloadedFile(_TaskInfo task) {
    //onClickInstallApk();
    return FlutterDownloader.open(taskId: task.taskId);
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    _tasks.addAll(_apk.map((document) =>
        _TaskInfo(name: document['name'], link: document['link'])));

    _items.add(_ItemHolder(name: 'APK'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }
    tasks?.forEach((task)
    {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });
    //Path Creation
    _localPath = (await AppUtil.findLocalPath(platform,'.Download'));

    print('Local Path $_localPath');

  }

  void showCustomDialog()
  {
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(message: 'File downloading....');

    pr.show();

  }




}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}
