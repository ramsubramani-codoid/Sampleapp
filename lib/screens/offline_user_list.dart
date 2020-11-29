import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleapp/models/offline_userlist_object.dart';
import 'package:sampleapp/utils/Database.dart';
import 'package:sampleapp/utils/constants.dart';


class Offlineuserlist extends StatefulWidget {
  @override
  _Offlineuserlist createState() => new _Offlineuserlist();
}

class _Offlineuserlist extends State<Offlineuserlist> {

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool listsort=false;

  Future<Null> getofflineuserlistapi(String url) async {
    final response = await http.get(url);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final responseJson = json.decode(response.body);
    setState(() {
      for(Map user in responseJson['data']){
        offlineuserlist.add(Offlineuser.fromJson(user));
        OfflineuserDB.db.addofflineuser(Offlineuser.fromJson(user));
      }
    });
  }
  Future<bool> _onWillPop() async {
    return (await     showDialog(
        context: context,
        child:  CupertinoAlertDialog(
          title: Text("Message"),
          content: Text( "Are you sure you want to exit ?"),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
                child: Text("No")
            ),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text("Yes")
            ),
          ],
        ))

    );
  }
  ShowDialog(String whocalling ,String Message ,int id){
    showDialog(
        context: context,
        child:  CupertinoAlertDialog(
          title: Text("Message"),
          content: Text(Message),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("No")
            ),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  if(whocalling=="Delete"){
                    var s= await  OfflineuserDB.db.deleteofflineuser(id);
                     offlineuserlist.clear();
                    check_offlineuserlist_data_status();
                  }
                  Navigator.of(context).pop();
                },
                child: Text("Yes")
            ),
          ],
        ));
  }

  check_offlineuserlist_data_status() async {
    var userlist = await   OfflineuserDB.db.getofflineuser();
    setState(() {
      for(Map user in userlist){
        offlineuserlist.add(Offlineuser.fromJson(user));
      }
      if(offlineuserlist.isEmpty){
        getofflineuserlistapi(API_URL+"api/users?page=1&per_page=12");
      }
      offlineuserlist.sort((a,b) =>a.id.compareTo(b.id));
    });
  }
 Future<Null> refreshList() async {
   refreshKey.currentState?.show(atTop: false);
   await Future.delayed(Duration(seconds: 2));
   setState(() {
     offlineuserlist.clear();
     check_offlineuserlist_data_status();
   });

   return null;
 }
  @override
  void initState() {
    super.initState();
    check_offlineuserlist_data_status();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop:_onWillPop,

    child:Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Sample App',textAlign: TextAlign.center,style:APP_STYLE),
          backgroundColor: Color.fromRGBO(77, 155, 215, 1),
          actions: [
            IconButton(
              icon: Icon(
                Icons.sort,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if(!listsort){
                    offlineuserlist.sort((b,a) =>a.id.compareTo(b.id));
                    listsort=true;
                  }
                  else{
                    offlineuserlist.sort((a,b) =>a.id.compareTo(b.id));
                    listsort=false;
                  }
                });
              },
            ),
          ],
        ),
    body: new Center(
        child:offlineuserlist.isNotEmpty?
        RefreshIndicator(child: Scrollbar(child: ListView.builder(

          itemBuilder: (BuildContext context, int index) {
            Offlineuser offlineuser = offlineuserlist.elementAt(index);
            return Container(
              child:Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.black, width: 1),
                  ),
                child: ListTile(
                  leading: ClipOval(
                      child:FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: "assets/images/App_logo.png",
                        image: offlineuser.avatar,
                        width: 50,
                        height: 50,
                      )),
                  title: new Text(offlineuser.first_name +" "+offlineuser.last_name),
                  subtitle: new Text(offlineuser.email),
                  trailing: new IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: () async {
                      ShowDialog("Delete","Are you sure you want to Delete ?",offlineuser.id);
                    },
                  ),
                  onTap: (){
                    Fluttertoast.showToast(
                        msg: "User ID "+offlineuser.id.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                )
              ),
            );
          },
          itemCount: offlineuserlist.length,
        )),onRefresh: refreshList
        ):new CircularProgressIndicator(),

    )));
  }

}