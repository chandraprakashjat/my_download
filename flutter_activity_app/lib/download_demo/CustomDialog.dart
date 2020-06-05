
import 'package:flutter/material.dart';
import 'Consts.dart';
import 'package:flutter_downloader/flutter_downloader.dart';


class CustomDialog extends StatelessWidget {
  final String title, buttonTextFirst, buttonTextSecond;
  final Image image;
  static const IconData fingerprint =
  IconData(0xe90d, fontFamily: 'MaterialIcons');
  CustomDialog({
    @required this.title,
    @required this.buttonTextFirst,
    @required this.buttonTextSecond,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context)
  {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 16.0),
              new Row(
                mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    
                    RaisedButton(onPressed:()
                    {
                      print('select');
                      Navigator.pop(context,buttonTextFirst);


                      },child: new Text(buttonTextFirst),padding: const EdgeInsets.all(10),),
                    SizedBox(width:20.0),
                    RaisedButton(onPressed: ()
                    {
                      print('select');
                      Navigator.pop(context,buttonTextSecond);

                    },child: new Text(buttonTextSecond),padding: const EdgeInsets.all(10),)
                  ]
              ),
              SizedBox(height: 24.0),

            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child:  new Icon(fingerprint, size: 100.0, color: Colors.black87),
            radius: Consts.avatarRadius,
          ),
        ),
      ],
    );
  }


}