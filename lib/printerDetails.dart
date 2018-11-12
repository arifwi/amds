import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/Menu.dart' as menu;
import 'package:amds/movementDevices.dart' as movementDevices;
import 'package:amds/utils/myClass.dart' as utils;
class MainPrinterDetails extends StatefulWidget {
  String  strDeviceId,
      strPN,
      strSN,
      str_selectedTypeId,
      str_selectedModelId,
      str_selectedEntityId,
      str_selectedTypeName,
      str_selectedModelName,
      str_selectedEntityName,
      str_selectedUser,
      str_selectedLocation,
      str_selectedUserId,
      str_selectedLocationId,
      str_AppUsername;

  MainPrinterDetails({
   this.strDeviceId,
    this.strSN,
    this.strPN,
    this.str_selectedTypeId,
    this.str_selectedModelId,
    this.str_selectedEntityId,
    this.str_selectedTypeName,
    this.str_selectedEntityName,
    this.str_selectedModelName,
    this.str_selectedLocation,
    this.str_selectedLocationId,
    this.str_selectedUser,
    this.str_selectedUserId,
    this.str_AppUsername,
  });
  @override
  _MainPrinterDetailsState createState() => _MainPrinterDetailsState();
}

class _MainPrinterDetailsState extends State<MainPrinterDetails> {
  String _selectedTypeId,
      _selectedModelId,
      _selectedEntityId,
      _selectedTypeName,
      _selectedModelName,
      _selectedEntityName,
      _selectedUser,
      _selectedUserId,
      _selectedLocation,
      _selectedLocationId,
      _deviceId,
      _sn,
      _pn,
      _appUsername;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Center(
                  child: _selectedTypeName == 'DESKTOP'
                      ? new Icon(
                          Icons.desktop_mac,
                          size: 80.0,
                        )
                      : _selectedTypeName == 'NOTEBOOK'
                          ? new Icon(
                              Icons.laptop,
                              size: 80.0,
                            )
                          : new Icon(
                              Icons.close,
                              size: 80.0,
                            ),
                ),
                new ListTile(
                  leading: new Text('DEVICE ID'),
                  title: new Text(':'),
                  trailing: Text(_deviceId.toString(),
                      style: new TextStyle(fontWeight: FontWeight.bold)),
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
                new ListTile(
                  leading: new Text('TYPE'),
                  title: new Text(':'),
                  trailing: Text(_selectedTypeName.toString(),
                      style: new TextStyle(fontWeight: FontWeight.bold)),
                ),
                
                new ListTile(
                  leading: new Text('MODEL'),
                  title: new Text(':'),
                  trailing: Text(
                    _selectedModelName.toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                new ExpansionTile(
                  leading: new Text('SERIAL'),
                  title: new Text(':'),
                  children: <Widget>[
                    Text(
                      _sn.toString(),
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                  //trailing: Text(_sn.toString(),
                  //  style: new TextStyle(fontWeight: FontWeight.bold)),
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
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => movementDevices.MainMovementDevices(
                    str_selectedTypeName: _selectedTypeName, 
                    str_selectedLocationId: _selectedLocationId,
                    str_selectedUserId: _selectedUserId,
                    str_selectedEntityId: _selectedEntityId,
                    str_selectedEntityName:  _selectedEntityName, 
                    str_selectedLocation: _selectedLocation,
                    strDeviceId: _deviceId, 
                    str_selectedUser: _selectedUser,
                  )
                ));
              },
              label: new Text('MOVE'),
            ),
            new Padding(
              padding: EdgeInsets.only(bottom: 10.0),
            ),
            new RaisedButton.icon(
              color: Colors.amber,
              onPressed: () {},
              icon: new Icon(Icons.edit),
              label: new Text('EDIT'),
            )
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
      if (widget.strSN != null) {
        _sn = widget.strSN.toUpperCase();
      }
      if(widget.strPN != null){
        _pn = widget.strPN.toUpperCase();
      }
      
      if (widget.str_selectedTypeName != null) {
        _selectedTypeId = widget.str_selectedTypeId;
        _selectedTypeName = widget.str_selectedTypeName.toUpperCase();
      }
      if (widget.str_selectedModelName != null) {
        _selectedModelId = widget.str_selectedModelId;
        _selectedModelName = widget.str_selectedModelName.toUpperCase();
      }
      if (widget.str_selectedEntityName != null) {
        _selectedEntityId = widget.str_selectedEntityId;
        _selectedEntityName = widget.str_selectedEntityName.toUpperCase();
      }

      if (widget.str_selectedUser != null) {
        _selectedUserId = widget.str_selectedUserId;
        _selectedUser = widget.str_selectedUser.toUpperCase();
      }
      if (widget.str_selectedLocation != null) {
        _selectedLocationId = widget.str_selectedLocationId;
        _selectedLocation = widget.str_selectedLocation.toUpperCase();
      }
      _appUsername = widget.str_AppUsername;
           
    });
  }
}
