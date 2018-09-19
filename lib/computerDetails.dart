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
        child: new Column(
          children: <Widget>[
            new Center(
              child: _selectedTypeName == 'DESKTOP' 
                  ? new Icon(Icons.desktop_windows, size: 80.0,)
                  : _selectedTypeName == 'NOTEBOOK'
                      ? new Icon(Icons.laptop,size: 80.0,)
                      : new Icon(Icons.close,size: 80.0,),
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
              children: <Widget>[
                new Text('ID',),
                new Text(':'),
                new Text(_deviceId.toString(),style: new TextStyle(fontWeight: FontWeight.bold)),

              ],
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                 new Text('USERNAME'),
              new Text(':'),
              new Text(_deviceId.toString(),style: new TextStyle(fontWeight: FontWeight.bold)),
                
              ],
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
