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
import 'package:amds/printerList.dart' as printerList;
import 'package:amds/utils/myClass.dart' as utils;

class MainMovementDevices extends StatefulWidget {
  String strdeviceType,
      strDeviceId,
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
      str_current_states,
      str_current_locationname,
      str_deviceStatesId,
      str_deviceStatesName;

  MainMovementDevices({
    this.strdeviceType,
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
    this.str_current_states,
    this.str_deviceStatesName,
    this.str_deviceStatesId,
  });
  @override
  _MainMovementDevicesState createState() => _MainMovementDevicesState();
}

class _MainMovementDevicesState extends State<MainMovementDevices> {
  String _deviceType,
      _selectedEntityId,
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
      _current_entityname,
      _current_statesname,
      _deviceStatesId,
      _deviceStatesName;

  String isSuccessUpdate;
  String _appUsername;

  String url = utils.defaultUrl;
  List<DropdownMenuItem<String>> dataEntities = [];
  List<DropdownMenuItem<String>> dataStates = [];
  List<MapIdName> _listDataEntities = [];
  List<MapIdName> _searchEntitiesResult = [];
  List<MapIdName> _listDataStates = [];
  List<MapIdName> _searchStatesResult = [];

  bool unmove = true;

  Icon _icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            centerTitle: true,
            title: Text(_deviceId.toString(),
                style: new TextStyle(fontWeight: FontWeight.bold)),
            leading: _icon),
        body: unmove
            ? new Stack(children: <Widget>[
                ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 35.0),
                      child: new Center(
                          child: new Text(
                        'CURRENT DETAILS',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: Colors.blue),
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
                    new ListTile(
                      leading: new Text('STATUS'),
                      title: new Text(':'),
                      trailing: Text(_deviceStatesName.toString(),
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
                                    strdeviceType: _deviceType,
                                        str_deviceStatesId: _deviceStatesId,
                                    str_AppUsername: _appUsername,
                                        str_deviceStatesName: _deviceStatesName,
                                        str_current_states: _current_statesname,
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
                                    strdeviceType: _deviceType,
                                    str_AppUsername: _appUsername,
                                        str_deviceStatesId: _deviceStatesId,
                                        str_deviceStatesName: _deviceStatesName,
                                        str_current_states: _current_statesname,
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
                      leading: new Text('STATES'),
                      title: new Text(':'),
                    ),
                    new Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: new DropdownButtonHideUnderline(
                        child: DropdownButton(
                          iconSize: 20.0,
                          style: TextStyle(fontSize: 17.0, color: Colors.black),
                          value: _deviceStatesId,
                          items: dataStates,
                          hint: Text('Select States'),
                          onChanged: (value) {
                            setState(() {
                              _searchStatesResult = [];

                              _deviceStatesId = value;
                              _listDataStates.forEach((MapStates) {
                                if (MapStates.id.contains(_deviceStatesId))
                                  _searchStatesResult.add(MapStates);
                              });
                              _deviceStatesName = _searchStatesResult[0].name;
                            });
                          },
                        ),
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
                              _current_username == _selectedUser &&
                              _current_statesname == _deviceStatesName) {
                            setState(() {
                              isSuccessUpdate = "Nothing Change!";
                            });
                            successDialog();
                          } else {
                            updateDevices(
                                    _deviceId,
                                    _selectedEntityId,
                                    _deviceType,
                                    _selectedLocationId,
                                    _selectedUserId)
                                .then((result) {
                              new Future.delayed(Duration(milliseconds: 1000),
                                  () {
                                if (isSuccessUpdate ==
                                    "$_deviceId updated successfully") {
                                  if (_deviceType == "COMPUTERS") {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                computerList.HomePage(
                                                  str_AppUsername: _appUsername,
                                                )));
                                  }
                                  else if(_deviceType =="PRINTERS"){
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                printerList.HomePage(
                                                  str_AppUsername: _appUsername,
                                                )));
                                  }
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
    _deviceType = widget.strdeviceType;
    print(_appUsername);
    getEntities().then((result) {
      getStates().then((onValue) {
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
          if (widget.str_deviceStatesId != null) {
            _deviceStatesId = widget.str_deviceStatesId;
            _deviceStatesName = widget.str_deviceStatesName;
          }
          if (widget.str_current_entityname != null ||
              widget.str_current_locationname != null ||
              widget.str_current_username != null ||
              widget.str_current_states != null) {
            _current_entityname = widget.str_current_entityname.toUpperCase();
            _current_locationname =
                widget.str_current_locationname.toUpperCase();
            _current_username = widget.str_current_username.toUpperCase();
            _current_statesname = widget.str_current_states.toUpperCase();
          }

          if (widget.str_current_entityname == null ||
              widget.str_current_locationname == null ||
              widget.str_current_username == null ||
              widget.str_current_states == null) {
            _current_entityname = _selectedEntityName.toUpperCase();
            _current_locationname = _selectedLocation.toUpperCase();
            _current_username = _selectedUser.toUpperCase();
            _current_statesname = _deviceStatesName.toUpperCase();
          }
          
            if (_deviceType == "COMPUTERS") {
              _selectedTypeName == 'DESKTOP'
                  ? _icon = new Icon(
                      Icons.desktop_mac,
                    )
                  : _selectedTypeName == 'NOTEBOOK'
                      ? _icon = new Icon(
                          Icons.laptop,
                        )
                      : _icon = new Icon(
                          Icons.close,
                        );
            } else if (_deviceType == "PRINTERS") {
              _icon = new Icon(
                Icons.print,
              );
            }
          
        });
      });
    });
  }

  Future updateDevices(String deviceID, String entities_id, String deviceType,
      String locations_id, String users_id) async {
    String result;
    setState(() {
      if (deviceType == "COMPUTERS") {
        deviceType = "glpi_computers";
      } else if (deviceType == "PRINTERS") {
        deviceType = "glpi_printers";
      }
    });

    final response = await http.post(url + 'movementDevices.php', body: {
      'devicetype': deviceType,
      'id': deviceID,
      'user_id': users_id,
      'location_id': locations_id,
      'entities_id': entities_id,
      'states_id': _deviceStatesId,
      'appUsername': _appUsername.toString(),
      'old_value':
          "$_current_entityname > $_current_locationname; User: $_current_username; States: $_current_statesname",
      'new_value':
          "$_selectedEntityName > $_selectedLocation; User: $_selectedUser; States: $_deviceStatesName",
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

  Future getStates() async {
    try {
      final getStatesResult = await http.get(url + 'getStates.php');

      final getDataStates = json.decode(getStatesResult.body);

      dataStates = [];
      //txtselectedType = getdataType;
      for (Map i in getDataStates) {
        _listDataStates.add(MapIdName.fromJson(i));
      }

      for (var i = 0; i < _listDataStates.length; i++) {
        Color color;
        if (i % 2 != 0) {
          color = Colors.amber;
        } else {
          color = Colors.blue[300];
        }
        dataStates.add(new DropdownMenuItem(
          child: new Text(
            (_listDataStates[i].name),
            style: new TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          value: _listDataStates[i].id.toString(),
        ));
      }
      return dataStates;
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
