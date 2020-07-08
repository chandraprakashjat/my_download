import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieList extends StatelessWidget 
{
  List<String> list;
  MovieList({this.list});
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('App Gallery'),
      ),
      body: buildList(list),
    );
  }

  Widget buildList(List<String> list) {

    return GridView.builder(
      itemCount: list.length,
      gridDelegate:
      new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index)
        {
        return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Image.file(File(list[index]))
        );

         }

    );
  }



}