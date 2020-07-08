
import 'dart:io';
import 'package:path/path.dart' as path;

class ImageExtension
{

  ImageExtension._privateConstructor();



  static final ImageExtension instance = ImageExtension._privateConstructor();

  factory ImageExtension()
  {
    return instance;
  }



  static Future<String> getFileNameWithExtension(File file)async{

    if(await file.exists()){

      //To get file name without extension
      //path.basenameWithoutExtension(file.path);

      //return file with file extension
      return path.basename(file.path);
    }else{
      return null;
    }
  }


 // During write operation
  String getAppSpecificExtension(String currentExtension)
  {
    currentExtension = currentExtension.toUpperCase();


    switch(currentExtension)
    {
      case 'PNG':

        return 'fabP';

      case 'JPEG':
        return 'fabJ';


      case 'BMP':

        return 'fabB';

      case 'GIF':

        return 'fabG';

      case 'WEBP':

        return 'fabW';

      case 'HEIF':

        return 'fabH';

    }

    return 'fabU'; // for un konown file
  }



  // During Read operation

  String getExtension(String currentExtension)
  {

    switch(currentExtension)
    {
      case 'fabP':

        return 'PNG';

      case 'fabJ':
        return 'JPEG';


      case 'fabB':

        return 'BMP';

      case 'fabG':

        return 'GIF';

      case 'fabW':

        return 'WebP';

      case 'fabH':

        return 'HEIF';

    }

    return 'PNG'; // for un konown file
  }

  void reWriteExtension(String name, String localPath)
  {

    var directory = Directory(localPath);

    List files = directory.listSync();

    files.forEach((element)
    async {
      String fileNameWithExtension =  await getFileNameWithExtension(element);

      if(!fileNameWithExtension.contains('fab'))
        {

         String fileName =  path.basenameWithoutExtension(element.path);
          List<String>  extension = fileNameWithExtension.split(fileName+'.');

          element.rename(File(localPath+fileName+'.'+getAppSpecificExtension(extension[1])).path);
        }

      print(element);
    });
  }


  void getAllFiles(String localPath, Function function) async
  {

    var directory = Directory(localPath);
    List<FileSystemEntity> files = directory.listSync();
    List<String> list = List();

    files.forEach((element)
     async {

      if(element.path.contains('fab'))
      {

        /*String fileName =  path.basenameWithoutExtension(element.path);
        List<String>  extension = fileNameWithExtension.split(fileName+'.');

        String name = File(localPath+fileName+'.'+(extension[1])).path;
        print(name);*/

       list.add(element.path);
      }


    });


    Future.delayed(Duration(seconds: 3)).then((value)
    {
     return function(list);

    });






  }

}