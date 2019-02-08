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
      allComputerCounter,
      allPrinterCounter,
      allMonitorCounter,
      activeComputerCounter,
      activePrinterCounter,
      activeMonitorCounter,
      onServiceComputerCounter,
      onServicePrinterCounter,
      onServiceMonitorCounter,
      dispossedComputerCounter,
      dispossedPrinterCounter,
      dispossedMonitorCounter,
      damagedPrinterCounter,
      damagedComputerCounter,
      damagedMonitorCounter,
      spareComputerCounter,
      sparePrinterCounter,
      spareMonitorCounter;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        new GlobalKey<RefreshIndicatorState>();
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return WillPopScope(
      onWillPop: backButtonDialog,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Main Menu'),
          

          //new Text("${widget.username}"),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          key: _refreshIndicatorKey,
          child: new GridView.count(
            crossAxisCount: 2,
            childAspectRatio: (itemWidth / itemHeight),
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
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('All :  '),
                        Text(
                          '$allComputerCounter Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
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
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Spare :  '),
                        Text(
                          '$spareComputerCounter Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.cyan),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
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
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
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
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Dispossed :  '),
                        Text(
                          '$dispossedComputerCounter Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
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
                        Icons.print,
                        size: 75.0,
                      ),
                      Text(
                        'Printers',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('All :  '),
                          Text(
                            '$allPrinterCounter Unit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Active :  '),
                          Text(
                            '$activePrinterCounter Unit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Spare :  '),
                          Text(
                            '$sparePrinterCounter Unit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('On Service :  '),
                          Text(
                            '$onServicePrinterCounter Unit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
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
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Dispossed :  '),
                          Text(
                            '$dispossedPrinterCounter Unit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
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
                      Icons.devices_other,
                      size: 75.0,
                    ),
                    Text(
                      'Mobile Devices',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                  Text("ON PROGERSS", style: TextStyle(fontSize: 30.0, color: Colors.red),textAlign: TextAlign.center,),
                      
                    
                  ],
                )),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => commputerlist.HomePage(
                  //               str_AppUsername: _appUsername,
                  //             )));
                },
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
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
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

  Future<dynamic> getDeviceStatus() async {
    try {
      //final counter = await http.get(url + 'getDeviceStatus.php');
      final response = await http.get(url + "getDeviceCounter.php");
      final getCounter = json.decode(response.body);
      setState(() {
        allComputerCounter = getCounter[0]["countAllComputer"];
        activeComputerCounter = getCounter[0]["countActiveComputer"];
        damagedComputerCounter = getCounter[0]["countDamagedComputer"];
        onServiceComputerCounter = getCounter[0]["countOnServiceComputer"];
        spareComputerCounter = getCounter[0]["countSpareComputer"];
        dispossedComputerCounter = getCounter[0]["countDispossedComputer"];

        allPrinterCounter = getCounter[0]["countAllPrinter"];
        activePrinterCounter = getCounter[0]["countActivePrinter"];
        damagedPrinterCounter = getCounter[0]["countDamagedPrinter"];
        onServicePrinterCounter = getCounter[0]["countOnServicePrinter"];
        sparePrinterCounter = getCounter[0]["countSparePrinter"];
        dispossedPrinterCounter = getCounter[0]["countDispossedPrinter"];
      });
    } catch (error) {
      print(error);
    }
  }

  Future<Null> _refresh() {
   return getDeviceStatus().then((onValue){
      
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appUsername = widget.str_AppUsername;

    getDeviceStatus().then((onValue) {
      if (allComputerCounter == null) {
        allComputerCounter = '-';
      }

      if (allPrinterCounter == null) {
        allPrinterCounter = '-';
      }

      if (activeComputerCounter == null) {
        activeComputerCounter = '-';
      }
      if (activePrinterCounter == null) {
        activePrinterCounter = '-';
      }

      if (onServiceComputerCounter == null) {
        onServiceComputerCounter = '-';
      }
      if (onServicePrinterCounter == null) {
        onServicePrinterCounter = '-';
      }

      if (spareComputerCounter == null) {
        onServiceComputerCounter = '-';
      }
      if (sparePrinterCounter == null) {
        onServicePrinterCounter = '-';
      }

      if (damagedComputerCounter == null) {
        damagedComputerCounter = '-';
      }
      if (dispossedComputerCounter == null) {
        dispossedComputerCounter = '-';
      }

      if (damagedPrinterCounter == null) {
        damagedPrinterCounter = '-';
      }
      if (dispossedPrinterCounter == null) {
        dispossedPrinterCounter = '-';
      }
    });
  }
}
