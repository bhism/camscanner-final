import 'package:flutter/material.dart';
import 'package:part3/thirdpage.dart';

import 'firstpage.dart';
import 'secondpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.indigo[900],
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "original \nimage",
              ),
              Tab(
                text: "Scan \nimage",
              ),
              Tab(
                text: "Draw \nimage",
              ),
            ],
          ),
          title: Text(
            'Make PDF',
          ),
        ),
        body: TabBarView(
          children: [
            Firstpage(),
            Secondpage(),
            thirdpage(),
          ],
        ),
      ),
    );
  }
}
