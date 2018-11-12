import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:amds/main.dart' as login;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/scanning.dart' as scan_adddevice;
import 'package:amds/computerList.dart' as commputerlist;
import 'package:amds/usersList.dart' as UserList;
import 'package:amds/monitorList.dart' as monitorList;
import 'package:amds/printerList.dart' as printerList;
import 'package:amds/utils/myClass.dart' as utils;

class mainMenu extends StatefulWidget {
  final String str_AppUsername;

  mainMenu({this.str_AppUsername});

  @override
  _mainMenuState createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu> {
  String _appUsername;
  String url = utils.defaultUrl,
      activeComputerCounter,
      activePrinterCounter,
      activeMonitorCounter,
      onServiceComputerCounter,
      onServicePrinterCounter,
      onServiceMonitorCounter,
      damagedComputerCounter,
      dispossedComputerCounter,
      damagedPrinterCounter,
      dispossedPrinterCounter,
      damagedMonitorCounter,
      dispossedMonitorCounter;

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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Active :  '),
                      Text(
                        '$activeComputerCounter Unit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('On Service :  '),
                      Text(
                        '$onServiceComputerCounter Unit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Damaged :  '),
                      Text(
                        '$damagedComputerCounter Unit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Dispossed :  '),
                      Text(
                        '$dispossedComputerCounter Unit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => commputerlist.HomePage(
                              str_AppUsername: _appUsername,
                            )));
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
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Active :  '),
                        Text(
                          '$activeMonitorCounter Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('On Service :  '),
                        Text(
                          '$activeMonitorCounter Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Damaged :  '),
                        Text(
                          '$damagedMonitorCounter Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Dispossed :  '),
                        Text(
                          '$dispossedMonitorCounter Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                )),
                onTap: () {}),
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
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Active :  '),
                        Text(
                          '$activePrinterCounter Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('On Service :  '),
                        Text(
                          '$onServicePrinterCounter Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Damaged :  '),
                        Text(
                          '$damagedPrinterCounter Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Dispossed :  '),
                        Text(
                          '$dispossedPrinterCounter Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => printerList.HomePage(
                                str_AppUsername: _appUsername,
                              )));
                }),
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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

  Future<dynamic> getActiveStatus() async {
    try {
      //final counter = await http.get(url + 'getActiveStatus.php');
      final response = await http.get(url + "getActiveStatus.php");
      final getCounter = json.decode(response.body);
      setState(() {
        activeComputerCounter = getCounter[0]["countComputer"];
        activePrinterCounter = getCounter[0]["countPrinter"];
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
    getActiveStatus().then((onValue){
              if(activeComputerCounter ==null){
                activeComputerCounter = '-';
              }
        if(activePrinterCounter ==null){
          activePrinterCounter = '-';
        }
        if(activeMonitorCounter ==null){
          activeMonitorCounter = '-';
        }
        if(onServiceComputerCounter ==null){
          onServiceComputerCounter = '-';
        }
        if(onServicePrinterCounter ==null){
          onServicePrinterCounter = '-';
        }
        if(onServiceMonitorCounter ==null){
          onServiceMonitorCounter = '-';
        }
        if(damagedComputerCounter ==null){
          damagedComputerCounter = '-';
        }
        if(dispossedComputerCounter ==null){
          dispossedComputerCounter = '-';
        }
        if(damagedPrinterCounter ==null){
          damagedPrinterCounter = '-';
        }
        if(dispossedPrinterCounter ==null){
          dispossedPrinterCounter = '-';
        }
        if(damagedMonitorCounter ==null){
          damagedMonitorCounter = '-';
        }
        if(dispossedMonitorCounter ==null){
          dispossedMonitorCounter = '-';
        }
    });
  }
}
