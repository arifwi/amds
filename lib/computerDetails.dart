import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/Menu.dart' as menu;

class MainComputerDetails extends StatefulWidget {
  String strDeviceId,
      strPN,
      strSN,
      str_selectedTypeName,
      str_selectedModelName,
      str_selectedEntityName,
      str_selectedUser,
      str_selectedLocation;

  MainComputerDetails({
    this.strDeviceId,
    this.strSN,
    this.strPN,
    this.str_selectedTypeName,
    this.str_selectedEntityName,
    this.str_selectedModelName,
    this.str_selectedLocation,
    this.str_selectedUser,
  });
  @override
  _MainComputerDetailsState createState() => _MainComputerDetailsState();
}

class _MainComputerDetailsState extends State<MainComputerDetails> {
  String _selectedTypeName,
      _selectedModelName,
      _selectedEntityName,
      _selectedUser,
      _selectedLocation,
      _deviceId,
      _sn,
      _pn;

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
                          Icons.desktop_windows,
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
                new ListTile(
                  leading: new Text('PRODUCT NUMBER'),
                  title: new Text(':'),
                  trailing: Text(_pn.toString(),
                      style: new TextStyle(fontWeight: FontWeight.bold)),
                ),
                new ListTile(
                  leading: new Text('SERIAL NUMBER'),
                  title: new Text(':'),
                  trailing: Text(_sn.toString(),
                      style: new TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            new RaisedButton(
              onPressed: (){},
              child: new Text('MOVE'),
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
      if (widget.strPN != null) {
        _pn = widget.strPN.toUpperCase();
      }
      if (widget.str_selectedTypeName != null) {
        _selectedTypeName = widget.str_selectedTypeName.toUpperCase();
      }
      if (widget.str_selectedModelName != null) {
        _selectedModelName = widget.str_selectedModelName.toUpperCase();
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
    print(_selectedTypeName);
  }
}
