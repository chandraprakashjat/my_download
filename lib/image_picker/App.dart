import 'package:flutter/material.dart';

import 'MovieList.dart';

class App extends StatelessWidget
{
  List<String> list;
  App(this.list);
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      theme: ThemeData.fallback(),
      home: Scaffold(
        body: MovieList(list:list),
      ),
    );
  }
}