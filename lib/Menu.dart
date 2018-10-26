import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:amds/main.dart' as login;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/scan.dart' as scanner;
import 'package:amds/scanning.dart' as scan_adddevice;
import 'package:amds/computerList.dart' as commputerlist;
import 'package:amds/usersList.dart' as UserList;
import 'package:amds/monitorList.dart' as monitorList;
import 'package:amds/printerList.dart' as printerList;
class mainMenu extends StatefulWidget {
  final String str_AppUsername;
  

  mainMenu({this.str_AppUsername});

  @override
  _mainMenuState createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu> {
  String _appUsername;
  String url = 'http://172.28.16.84:8089/', activeComputer = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backButtonDialog,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Main Menu'),

          //new Text("${widget.username}"),
        ),
        body: new GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            new GestureDetector(
              child: new Card(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.computer,
                    size: 75.0,
                  ),
                  Text(
                    'Computers',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text('Active : $activeComputer Unit'),
                  Text('On Serivice :'),

                ],
              )),
              onTap: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) => commputerlist.HomePage(str_AppUsername: _appUsername,)));
              },
            ),
            new GestureDetector(
              child: new Card(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.desktop_windows,
                    size: 75.0,
                  ),
                  Text(
                    'Monitors',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text('Active :'),
                  Text('On Serivice :'),
                ],
              )),
              onTap: () {
              }
            ),
            new GestureDetector(
              child: new Card(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.print,
                    size: 75.0,
                  ),
                  Text(
                    'Printers',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text('Active :'),
                  Text('On Serivice :'),
                ],
              )),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> printerList.HomePage(str_AppUsername: _appUsername,)));
              }
            ),
            new GestureDetector(
              child: new Card(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.reply,
                    size: 75.0,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => login.MyApp()),
                );
              },
            ),
            
          ],
        ),
      ),
    );
  }
  
  Future<bool> backButtonDialog() {
    AlertDialog alertScanDeviceid = new AlertDialog(
      title: new Text('Exit Dialog', style: new TextStyle(color: Colors.blue)),
      content: new Text('Do you want to exit from this application?'),
      actions: <Widget>[
        new RaisedButton.icon(
          color: Colors.blue,
          icon: new Icon(
            Icons.close,
            color: Colors.white,
          ),
          label: new Text(
            'No',
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        new RaisedButton.icon(
          color: Colors.blue,
          icon: new Icon(Icons.exit_to_app, color: Colors.white),
          label: new Text(
            'Yes',
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: () {
            exit(0);
            //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> menu.mainMenu()));
          },
        )
      ],
    );
    return showDialog(context: context, child: alertScanDeviceid);
  }
  
  Future<dynamic> getActiveStatus(String devicesType) async {
    try {
      //final counter = await http.get(url + 'getActiveStatus.php');
    final response = await http.post(url + "getActiveStatus.php", body: {
        'devicesType' : devicesType,
      });
    print(response.body);
    setState(() {
          activeComputer = response.body;
        });
    } catch (error) {
      print(error);
    }
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _appUsername = widget.str_AppUsername;
      getActiveStatus();
    }
}
