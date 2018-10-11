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
      str_selectedLocation;

  MainMovementDevices({
    this.strDeviceId,
    this.str_selectedTypeName,
    this.str_selectedEntityName,
    this.str_selectedLocation,
    this.str_selectedUser,
  });
  @override
  _MainMovementDevicesState createState() => _MainMovementDevicesState();
}

class _MainMovementDevicesState extends State<MainMovementDevices> {
  String _selectedTypeName,
      _selectedModelName,
      _selectedEntityName,
      _selectedUser,
      _selectedLocation,
      _deviceId;
    
  bool unmove = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title:Text(_deviceId.toString(),
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
      body:unmove? Container(
        margin: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Center(
                  child :new Text('CURRENT DETAILS', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.red),)
                ),
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
      ):Container(
        margin: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Center(
                  child :new Text('CURRENT DETAILS', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.red),)
                ),
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
              color: Colors.red,
              icon: new Icon(Icons.navigate_next),
              onPressed: () {
                setState(() {
                unmove = true;
                                  
                                });
              },
              label: new Text('MOVE'),
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
