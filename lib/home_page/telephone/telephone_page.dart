import 'package:flutter/material.dart';
import 'data.dart';
import 'constants.dart';
import 'ServiceLocator.dart';
import 'TelAndSmsService.dart';
import 'add_contact_page.dart';
import 'package:lexiyang/home_page/telephone/contact_database.dart';

//家人联系电话
List<ContactDB> familyList = [];

//顶部为滑动导航栏，分别对应 家人 服务 紧急 的联系方式
class TelephonePage extends StatefulWidget {

  @override
  TelephonePageState createState() {
    return TelephonePageState();
  }
}

class TelephonePageState extends State<TelephonePage> {

  Future<List<ContactDB>> getContacts () async {
    familyList = await DBProvider.db.getAllUser();
    setState(() {

    });
  }

  //从数据库加载家人联系电话
  @override
  void initState() {
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    //tabbar控制器
    return DefaultTabController(
      length: myTab.length,
      child: Scaffold(
        //endDrawer: Drawer(),
        appBar: AppBar(
          title: Text('联系人'),
          bottom: TabBar(
            //isScrollable: true,
            tabs: myTab.map((MyTab tab){
              return Tab(text: tab.title,);
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: myTab.map((MyTab tab){
            return ContactList(tab);
          }).toList(),
        ),
      ),
    );
  }
}

class ContactList extends StatefulWidget {

  MyTab tab;
  ContactList(this.tab);

  @override
  ContactListState createState() {
    return ContactListState();
  }
}

class ContactListState extends State<ContactList> {

  //拨打电话功能
  final TelAndSmsService _service = locator<TelAndSmsService>();

  var _list = [];

  //将ContactDB对象转换为Contact对象
  //数据库有自增长id,对应的类为ContactDB，而Contact类中有用户头像，不能达到统一，这里转换一下
  contactDB2contact() {
    _list.clear();
    for (int i=0; i<familyList.length; i++) {
      _list.add(new Contact(Icons.perm_identity, familyList[i].name, familyList[i].phone));
    }
  }

  @override
  Widget build(BuildContext context) {
    //判断数据类型
    if (widget.tab.category == MyConstants.FAMILY) {
      contactDB2contact();
    } else if (widget.tab.category == MyConstants.SERVICE) {
      _list = serviceList;
    } else if (widget.tab.category == MyConstants.EMERGENCY) {
      _list = emergencyList;
    }
    //返回tabbarview
    return Scaffold(
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int position) {
          return _getRow(position);
        },
      ),
      floatingActionButton: Container(
        //是第一页则显示fab按钮，否则显示空白
        child: widget.tab.category == MyConstants.FAMILY ?
        FloatingActionButton(onPressed: () {addContact(context);},child: Icon(Icons.add_call),) : Container(),
      ),
    );
  }

  //返回listview子项，即联系人布局
  Widget _getRow(int position) {
    return Padding(
      padding: EdgeInsets.only(left: 5.0,right: 5.0,top: 2.0),
      child: SizedBox(
        height: 100.0,
        child: Card(
          elevation: 2.0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: ListTile(
            leading: Icon(_list[position].icon,color: Colors.lightBlue,size: 60.0,),
            title: Text(_list[position].name,style: TextStyle(fontSize: 23.0),),
            subtitle: Row(children: <Widget>[
              Icon(Icons.call,size: 13.0,),
              Text(_list[position].phoneNumber),
            ],),
            trailing: IconButton(icon: Icon(Icons.chat_bubble_outline), onPressed: (){_service.sendSms(_list[position].phoneNumber);},iconSize: 20.0,),
            onTap: () {
              _service.call(_list[position].phoneNumber);
            },
            //长按弹出对话框提示是否删除
            onLongPress: () {
              //确保只能删除自己添加的联系人，服务电话和紧急电话无法删除
              if (widget.tab.category == MyConstants.FAMILY) {
                showAlertDialog(context,position);
              }
            },
          ),
        ),
      ),
    );
  }

  //弹出对话框，提示是否删除联系人
  void showAlertDialog(BuildContext context,int position) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("删除联系人"),
        content: new Text("是否删除该联系人？"),
        actions:<Widget>[
          new FlatButton(child:new Text("否"), onPressed: (){
            Navigator.of(context).pop();
          },),
          new FlatButton(child:new Text("是"), onPressed: (){
            familyList.removeAt(position);
            DBProvider.db.deleteByPhone(_list[position].phoneNumber);
            Navigator.of(context).pop();
            //刷新界面
            setState(() { });
          },)
        ]
      )
    );
  }

  //添加按钮的点击事件，添加新的联系人
  addContact(BuildContext context) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> AddContact()));
    if (result == 1) {
      setState(() { });
    }
  }
}