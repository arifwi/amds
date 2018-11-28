import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/Menu.dart' as menu;
import 'package:amds/movementDevices.dart' as movementDevices;

class MainComputerDetails extends StatefulWidget {
  String strDeviceId,
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
      str_AppUsername,
      str_deviceStatusId,
      str_deviceStatusName;

  MainComputerDetails({
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
    this.str_deviceStatusId,
    this.str_deviceStatusName
  });
  @override
  _MainComputerDetailsState createState() => _MainComputerDetailsState();
}

class _MainComputerDetailsState extends State<MainComputerDetails> {
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
      _appUsername,
      _deviceStatusId,
      _deviceStatusName;


  Color statusColor;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: Icon(Icons.info),
                text: "Details",
              ),
              Tab(icon: Icon(Icons.history), text: "History"),
            ],
          ),
          title: Text(_deviceId),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blueAccent,
          
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             
              FlatButton.icon(
                label: Text('Set/Move'),
                icon: Icon(Icons.navigate_next),
                onPressed: () {
                  Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  movementDevices.MainMovementDevices(
                                    str_AppUsername: _appUsername,
                                    str_selectedTypeName: _selectedTypeName,
                                    str_selectedLocationId: _selectedLocationId,
                                    str_selectedUserId: _selectedUserId,
                                    str_selectedEntityId: _selectedEntityId,
                                    str_selectedEntityName: _selectedEntityName,
                                    str_selectedLocation: _selectedLocation,
                                    strDeviceId: _deviceId,
                                    str_selectedUser: _selectedUser,
                                  )));
                },
              ),
              Text(
                "|",
                style: TextStyle(fontSize: 25.0),
              ),
              FlatButton.icon(
                label: Text('Edit'),
                icon: Icon(Icons.edit),
                onPressed: () {},
              ),
              Text(
                "|",
                style: TextStyle(fontSize: 25.0),
              ),
              FlatButton.icon(
                label: Text('Sending'),
                icon: Icon(Icons.send),
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
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

                      // new ListTile(
                      //   leading: new Text('DEVICE ID'),
                      //   title: new Text(':'),
                      //   trailing: Text(_deviceId.toString(),
                      //       style: new TextStyle(fontWeight: FontWeight.bold)),
                      // ),
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

                      // new ListTile(
                      //   leading: new Text('MODEL'),
                      //   title: new Text(':'),
                      //   trailing: Text(
                      //     _selectedModelName.toString(),
                      //     style: new TextStyle(fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      new ExpansionTile(
                        leading: new Text('MODEL'),
                        title: new Text(':'),
                        children: <Widget>[
                          Text(
                            _selectedModelName.toString(),
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                        //trailing: Text(_sn.toString(),
                        //  style: new TextStyle(fontWeight: FontWeight.bold)),
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
                      new ListTile(
                        
                        leading: new Text('STATUS'),
                        title: new Text(':'),
                        trailing: Text(_deviceStatusName.toString(),
                            style: new TextStyle(fontWeight: FontWeight.bold,color: statusColor)),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      )
                    ],
                  ),
                 
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                  ),
                  
                ],
              ),
            ),
            Center(child: Text("History Page")),
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
      if(widget.str_deviceStatusId != null){
        _deviceStatusId = widget.str_deviceStatusId;
        _deviceStatusName = widget.str_deviceStatusName;
        if(_deviceStatusName == "USED"){
          statusColor = Colors.green;
        }
        else if(_deviceStatusName == "DAMAGED"){
          statusColor = Colors.red;
        }
      }
      _appUsername = widget.str_AppUsername;

    });
  }
}


class MapDeviceLogs {
  //used by get selected type and selected model
  final String id,
      name,
      modelId,
      modelName,
      typeId,
      typeName,
      username,
      user_id,
      firstname,
      lastname,
      entities,
      entities_id,
      locations_id,
      locations,
      sn,
      pn,
      states_id,
      states_name;

  MapDeviceLogs(
      {this.id,
      this.name,
      this.modelId,
      this.modelName,
      this.typeId,
      this.typeName,
      this.firstname,
      this.lastname,
      this.username,
      this.user_id,
      this.entities,
      this.entities_id,
      this.locations_id,
      this.locations,
      this.pn,
      this.sn,
      this.states_id,
      this.states_name});

  factory MapDeviceLogs.fromJson(Map<String, dynamic> json) {
    return new MapDeviceLogs(
        id: json['id'],
        name: json['name'],
        modelId: json['model_id'],
        modelName: json['model_name'],
        typeId: json['type_id'],
        typeName: json['type_name'],
        username: json['username'],
        user_id: json['userid'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        entities: json['entities_name'],
        entities_id: json['entities_id'],
        locations: json['locations_name'],
        locations_id: json['locations_id'],
        sn: json['sn'],
        pn: json['pn'],
        states_id: json['states_id'],
        states_name: json['states_name']);
  }
}
