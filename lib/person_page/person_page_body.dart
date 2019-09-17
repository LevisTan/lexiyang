import 'package:flutter/material.dart';

class PersonPage extends StatefulWidget {

  @override
  PersonPageState createState() {
    return PersonPageState();
  }
}

class PersonPageState extends State<PersonPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('我的'),
      ),
    );
  }
}