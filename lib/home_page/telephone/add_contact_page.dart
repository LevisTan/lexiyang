import 'package:flutter/material.dart';
import 'telephone_page.dart';
import 'package:lexiyang/home_page/telephone/contact_database.dart';

//添加联系人,目前只能在第一页添加，添加的数据也将显示在第一页
class AddContact extends StatelessWidget {

  String phoneNumber;
  String name;

  TextEditingController phoneController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  //向列表中添加数据
  addContactData(BuildContext context) {
    phoneNumber = phoneController.text;
    name = nameController.text;
    //需要修改为ContactDB对象
    ContactDB contactDB = new ContactDB();
    contactDB.name = name;
    contactDB.phone = phoneNumber;
    familyList.add(contactDB);
    //向数据库插入数据
    DBProvider.db.insert(contactDB);
    //返回1，表示添加成功
    Navigator.pop(context,1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加联系人'),
      ),
      body: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            SizedBox(
              height: 45.0,
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0),
              child: new Stack(
                alignment: new Alignment(1.0, 1.0),
                //statck
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Padding(
                        padding: new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                        child: Icon(Icons.perm_identity,size: 35.0,color: Colors.lightBlue,),
                      ),
                      new Expanded(
                        child: new TextField(
                          controller: nameController,
                          decoration: new InputDecoration(
                            hintText: '请输入用户姓名',
                          ),
                        ),
                      ),
                    ]),
                  new IconButton(
                    icon: new Icon(Icons.clear, color: Colors.black45),
                    onPressed: () {
                      nameController.clear();
                    },
                  ),
                ],
              ),
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 40.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                    child: Icon(Icons.call,size: 35.0,color: Colors.lightBlue,),
                  ),
                  new Expanded(
                    child: new TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: new InputDecoration(
                        hintText: '请输入手机号码',
                        suffixIcon: new IconButton(
                          icon: new Icon(Icons.clear, color: Colors.black45),
                          onPressed: () {
                            phoneController.clear();
                          },
                        ),
                      ),
                      //obscureText: true,
                    ),
                  ),
                ]),
            ),
            new Container(
              width: 340.0,
              child: new Card(
                color: Colors.blue,
                elevation: 16.0,
                child: new FlatButton(
                  child: new Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Text(
                      '完成',
                      style: new TextStyle(
                        color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  onPressed: () {addContactData(context);}, //必须写成这种形式，不然报错
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

