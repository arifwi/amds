import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/Menu.dart' as menu;

class MainMovementDevices extends StatefulWidget {
  String strDeviceId,
      str_selectedTypeName,
      str_selectedEntityName,
      str_selectedUser,
      str_selectedLocation,
    str_selectedEntityId;

  MainMovementDevices({
    this.strDeviceId,
    this.str_selectedTypeName,
    this.str_selectedEntityName,
    this.str_selectedLocation,
    this.str_selectedUser,
    this.str_selectedEntityId,
  });
  @override
  _MainMovementDevicesState createState() => _MainMovementDevicesState();
}

class _MainMovementDevicesState extends State<MainMovementDevices> {
  String _selectedTypeName,
      _selectedEntityName,
      _selectedUser,
      _selectedLocation,
      _deviceId,
      _selectedEntityId;


  String url = 'http://172.28.16.84:8089/';
  List<DropdownMenuItem<String>> dataEntities = [];

  bool unmove = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(_deviceId.toString(),
            style: new TextStyle(fontWeight: FontWeight.bold)),
        leading: _selectedTypeName == 'DESKTOP'
            ? new Icon(
                Icons.desktop_windows,
              )
            : _selectedTypeName == 'NOTEBOOK'
                ? new Icon(
                    Icons.laptop,
                  )
                : new Icon(
                    Icons.close,
                  ),
      ),
      body: unmove
          ? Container(
              margin: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Center(
                          child: new Text(
                        'CURRENT DETAILS',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.red),
                      )),
                      new ListTile(
                        leading: new Text('USERNAME'),
                        title: new Text(':'),
                        trailing: Text(_selectedUser.toString(),
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      new ListTile(
                        leading: new Text('ENTITIES'),
                        title: new Text(':'),
                        trailing: Text(_selectedEntityName.toString(),
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      new ListTile(
                        leading: new Text('LOCATION'),
                        title: new Text(':'),
                        trailing: Text(_selectedLocation.toString(),
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      )
                    ],
                  ),
                  new RaisedButton.icon(
                    color: Colors.blue,
                    icon: new Icon(Icons.navigate_next),
                    onPressed: () {
                      setState(() {
                        unmove = false;
                      });
                    },
                    label: new Text('MOVE'),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                  ),
                ],
              ),
            )
          : Container(
              margin: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Center(
                          child: new Text(
                        'MOVE TO:',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.blue),
                      )),
                      new ListTile(
                        leading: new Text(
                          'USERS :',
                        ),
                        title: _selectedLocation == null
                            ? new Text('')
                            : new Text(_selectedLocation.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                        trailing: new IconButton(
                          icon: new Icon(Icons.search),
                          color: Colors.blue,
                          onPressed: () {},
                        ),
                      ),
                      new ListTile(
                        leading: new Text('ENTITIES'),
                        title: new Text(':'),
                        trailing: Text(_selectedEntityName.toString(),
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      new ListTile(
                        leading: new Text(
                          'LOCATION :',
                        ),
                        title: _selectedLocation == null
                            ? new Text('')
                            : new Text(_selectedLocation.toString()),
                        trailing: new IconButton(
                          icon: new Icon(Icons.search),
                          color: Colors.blue,
                          onPressed: () {},
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      )
                    ],
                  ),
                  new RaisedButton.icon(
                    color: Colors.blue,
                    icon: new Icon(Icons.save),
                    onPressed: () {
                      setState(() {
                        unmove = true;
                      });
                    },
                    label: new Text('SAVE'),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if (widget.strDeviceId != null) {
        _deviceId = widget.strDeviceId.toUpperCase();
      }

      if (widget.str_selectedTypeName != null) {
        _selectedTypeName = widget.str_selectedTypeName.toUpperCase();
      }

      if (widget.str_selectedEntityName != null) {
        _selectedEntityName = widget.str_selectedEntityName.toUpperCase();
      }

      if (widget.str_selectedUser != null) {
        _selectedUser = widget.str_selectedUser.toUpperCase();
      }
      if (widget.str_selectedLocation != null) {
        _selectedLocation = widget.str_selectedLocation.toUpperCase();
      }
    });
  }
}
class MapIdName {
  //used by get selected type and selected model
  final String id;
  final String name;

  MapIdName({this.id, this.name});

  factory MapIdName.fromJson(Map<String, dynamic> json) {
    return new MapIdName(
      id: json['id'],
      name: json['name'],
    );
  }
}
