import 'dart:async';
import 'dart:convert';
import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/Menu.dart' as menu;
import 'package:amds/usersList.dart' as UsersList;
import 'package:amds/locationsList.dart' as LocationsList;
import 'package:amds/computerList.dart' as computerList;
import 'package:amds/utils/myClass.dart' as utils;

class MainMovementDevices extends StatefulWidget {
  String strDeviceId,
      str_selectedEntityId,
      str_selectedTypeName,
      str_selectedEntityName,
      str_selectedUser,
      str_selectedLocation,
      str_selectedUserId,
      str_selectedLocationId,
      strPageIdentity,
      str_AppUsername,
      str_current_username,
      str_current_entityname,
      str_current_locationname;

  MainMovementDevices({
    this.strDeviceId,
    this.str_selectedEntityId,
    this.str_selectedTypeName,
    this.str_selectedEntityName,
    this.str_selectedLocation,
    this.str_selectedLocationId,
    this.str_selectedUser,
    this.str_selectedUserId,
    this.strPageIdentity,
    this.str_AppUsername,
    this.str_current_username,
    this.str_current_entityname,
    this.str_current_locationname,
  });
  @override
  _MainMovementDevicesState createState() => _MainMovementDevicesState();
}

class _MainMovementDevicesState extends State<MainMovementDevices> {
  String _selectedEntityId,
      _selectedTypeName,
      _selectedEntityName,
      _selectedUser,
      _selectedUserId,
      _selectedLocation,
      _selectedLocationId,
      _deviceId,
      _pageIdentity,
      _current_locationname,
      _current_username,
      _current_entityname;

  String isSuccessUpdate;
  String _appUsername;

  String url = utils.defaultUrl;
  List<DropdownMenuItem<String>> dataEntities = [];
  List<MapIdName> _listDataEntities = [];
  List<MapIdName> _searchEntitiesResult = [];

  bool unmove = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: Text(_deviceId.toString(),
          
              style: new TextStyle(fontWeight: FontWeight.bold)),
          leading: _selectedTypeName == 'DESKTOP'
              ? new Icon(
                  Icons.desktop_mac,
                )
              : _selectedTypeName == 'NOTEBOOK'
                  ? new Icon(
                      Icons.laptop,
                    )
                  : _selectedTypeName == 'PRINTER'?
                  new Icon(
                      Icons.local_printshop,
                    )
                  : new Icon(
                      Icons.close,
                    ),
        ),
        body: unmove
            ? new Stack(children: <Widget>[
                ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20.0,bottom: 35.0),
                      child: new Center(
                          child: new Text(
                        'CURRENT DETAILS',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: Colors.blue
                            ),
                      )),
                    ),
                    new ListTile(
                      leading: new Text('USERNAME'),
                      title: new Text(':'),
                      trailing: Text(_selectedUser.toString(),
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber)),
                    ),
                    new ListTile(
                      leading: new Text('ENTITIES'),
                      title: new Text(':'),
                      trailing: Text(_selectedEntityName.toString(),
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber)),
                    ),
                    new ListTile(
                      leading: new Text('LOCATION'),
                      title: new Text(':'),
                      trailing: Text(_selectedLocation.toString(),
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber)),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: new RaisedButton.icon(
                        color: Colors.blue,
                        icon: new Icon(Icons.navigate_next),
                        onPressed: () {
                          //change to 'move to'
                          setState(() {
                            unmove = false;
                          });
                        },
                        label: new Text('SET / MOVE'),
                      ),
                    ),
                  ],
                ),
              ])
            : new Stack(children: <Widget>[
                ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 35.0),
                      child: new Center(
                          child: new Text(
                        'MOVE / SET TO:',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: Colors.amber),
                      )),
                    ),
                    new ListTile(
                      leading: new Text('USERNAME'),
                      title: new Text(':'),
                    ),
                    new ListTile(
                      leading: _selectedLocation == null
                          ? new Text('')
                          : new Text(
                              _selectedUser.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber),
                            ),
                      trailing: new IconButton(
                        icon: new Icon(Icons.search),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            _pageIdentity = 'movementDevices';
                          });
                          //_navigateAndDisplaySelection(context);
                          //print(LocalHistoryRoute);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UsersList.HomePage(
                                        str_current_entityname:
                                            _current_entityname,
                                        str_current_locationname:
                                            _current_locationname,
                                        str_current_username: _current_username,
                                        strDeviceId: _deviceId,
                                        str_selectedEntityId: _selectedEntityId,
                                        str_selectedEntityName:
                                            _selectedEntityName,
                                        str_selectedTypeName: _selectedTypeName,
                                        str_selectedUserId: _selectedUserId,
                                        str_selectedUser: _selectedUser,
                                        str_selectedLocation: _selectedLocation,
                                        str_selectedLocationId:
                                            _selectedLocationId,
                                        strPageIdentity: _pageIdentity,
                                      )));
                        },
                      ),
                    ),
                    new ListTile(
                      leading: new Text('ENTITIES'),
                      title: new Text(':'),
                    ),
                    new Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: new DropdownButtonHideUnderline(
                        child: DropdownButton(
                          iconSize: 20.0,
                          style: TextStyle(fontSize: 17.0, color: Colors.black),
                          value: _selectedEntityId,
                          items: dataEntities,
                          hint: Text('Select Entitiy'),
                          onChanged: (value) {
                            setState(() {
                              _searchEntitiesResult = [];

                              _selectedEntityId = value;
                              _listDataEntities.forEach((MapTypeModel) {
                                if (MapTypeModel.id.contains(_selectedEntityId))
                                  _searchEntitiesResult.add(MapTypeModel);
                              });
                              _selectedEntityName =
                                  _searchEntitiesResult[0].name;
                            });
                          },
                        ),
                      ),
                    ),
                    new ListTile(
                      leading: new Text('LOCATION'),
                      title: new Text(':'),
                    ),
                    new ListTile(
                      leading: _selectedLocation == null
                          ? new Text('')
                          : new Text(
                              _selectedLocation.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber),
                            ),
                      trailing: new IconButton(
                        icon: new Icon(Icons.search),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            _pageIdentity = 'movementDevices';
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationsList.HomePage(
                                        str_current_entityname:
                                            _current_entityname,
                                        str_current_locationname:
                                            _current_locationname,
                                        str_current_username: _current_username,
                                        strDeviceId: _deviceId,
                                        str_selectedEntityId: _selectedEntityId,
                                        str_selectedEntityName:
                                            _selectedEntityName,
                                        str_selectedTypeName: _selectedTypeName,
                                        str_selectedUserId: _selectedUserId,
                                        str_selectedUser: _selectedUser,
                                        str_selectedLocation: _selectedLocation,
                                        str_selectedLocationId:
                                            _selectedLocationId,
                                        strPageIdentity: _pageIdentity,
                                      )));
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: new RaisedButton.icon(
                        color: Colors.blue,
                        icon: new Icon(Icons.save),
                        onPressed: () {
                          if (_current_entityname == _selectedEntityName &&
                              _current_locationname == _selectedLocation &&
                              _current_username == _selectedUser) {
                            setState(() {
                              isSuccessUpdate = "Nothing Change!";
                            });
                            successDialog();
                          } else {
                            updateDevices(
                                    _deviceId,
                                    _selectedEntityId,
                                    'glpi_computers',
                                    _selectedLocationId,
                                    _selectedUserId)
                                .then((result) {
                              new Future.delayed(Duration(milliseconds: 1000),
                                  () {
                                if (isSuccessUpdate ==
                                    "$_deviceId updated successfully") {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              computerList.HomePage()));
                                } else {
                                  Navigator.of(context, rootNavigator: true);
                                }
                              });
                              successDialog();
                            });
                          }
                        },
                        label: new Text('UPDATE'),
                      ),
                    ),
                  ],
                ),
              ]));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appUsername = widget.str_AppUsername;

    getEntities().then((result) {
      setState(() {
        if (widget.strDeviceId != null) {
          _deviceId = widget.strDeviceId.toUpperCase();
        }
        if (widget.str_selectedTypeName != null) {
          _selectedTypeName = widget.str_selectedTypeName.toUpperCase();
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
        if (widget.strPageIdentity != null) {
          if (widget.strPageIdentity == 'usersList' ||
              widget.strPageIdentity == 'locationsList') {
            _pageIdentity = widget.strPageIdentity;
            unmove = false;
          }
        }
        if (widget.str_current_entityname != null ||
            widget.str_current_locationname != null ||
            widget.str_current_username != null) {
          _current_entityname = widget.str_current_entityname.toUpperCase();
          _current_locationname = widget.str_current_locationname.toUpperCase();
          _current_username = widget.str_current_username.toUpperCase();
        }
        if (widget.str_current_entityname == null ||
            widget.str_current_locationname == null ||
            widget.str_current_username == null) {
          _current_entityname = _selectedEntityName.toUpperCase();
          _current_locationname = _selectedLocation.toUpperCase();
          _current_username = _selectedUser.toUpperCase();
        }

        // print(_selectedEntityId);
        //print(_selectedTypeName);
        // print(_selectedEntityName);
        // print(_selectedUser);
        //print(_selectedUserId);
        // print(_selectedLocation);
        // print(_selectedLocationId);
        // print(_deviceId);
      });
    });
  }

  Future updateDevices(String deviceID, String entities_id, String devicesType,
      String locations_id, String users_id) async {
    String result;

    final response = await http.post(url + 'movementDevices.php', body: {
      'devicetype': devicesType,
      'id': deviceID,
      'user_id': users_id,
      'location_id': locations_id,
      'entities_id': entities_id,
      'appUsername': _appUsername.toString(),
      'old_value':
          "$_current_entityname > $_current_locationname; User: $_current_username",
      'new_value':
          "$_selectedEntityName > $_selectedLocation; User: $_selectedUser",
    }).then((onValue) {
      if (onValue.body == "Record updated successfully") {
        result = "$deviceID updated successfully";
      } else {
        result = onValue.body.toString();
      }
      setState(() {
        isSuccessUpdate = result;
      });
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      setState(() {
        isSuccessUpdate = "Connection has Timeout";
      });
    }).catchError((onError) {
      print(onError);
      isSuccessUpdate = "Error!!";
    });
  }

  Future<bool> successDialog() {
    AlertDialog successInputInfo = new AlertDialog(
      title: new Text(
        'Information',
        style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      content: new Text(isSuccessUpdate),
    );
    return showDialog(context: context, child: successInputInfo);
  }

  Future getEntities() async {
    try {
      final getEntitiesResult = await http.get(url + 'getEntities.php');

      final getDataEntities = json.decode(getEntitiesResult.body);

      dataEntities = [];
      //txtselectedType = getdataType;
      for (Map i in getDataEntities) {
        _listDataEntities.add(MapIdName.fromJson(i));
      }

      for (var i = 0; i < _listDataEntities.length; i++) {
        Color color;
        if (i % 2 != 0) {
          color = Colors.amber;
        } else {
          color = Colors.blue[300];
        }
        dataEntities.add(new DropdownMenuItem(
          child: new Text(
            (_listDataEntities[i].name),
            style: new TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          value: _listDataEntities[i].id.toString(),
        ));
      }
      return dataEntities;
    } catch (error) {
      print(error);
    }
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
