import 'package:flutter/material.dart';
import 'package:lexiyang/person_page/person_page_appbar.dart';

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
      appBar: personAppBar,
      body: Center(
        child: Text('我的'),
      ),
    );
  }
}