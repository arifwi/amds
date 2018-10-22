import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/movementDevices.dart' as movementDevices;

class HomePage extends StatefulWidget {
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
      strPageIdentity;

  HomePage({
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
    this.strPageIdentity,
  });
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      _pageIdentity;
  TextEditingController controller = new TextEditingController();

  List<MapIdName> _searchResult = [];

  List<MapIdName> _userDetails = [];

  String fullname;

  //final String url = 'http://192.168.43.62/amdsweb/getUsers.php';
  final String url = 'http://172.28.16.84:8089/getUsers.php';

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(MapIdName.fromJson(user));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getUserDetails().then((value) {
      if (widget.strDeviceId != null) {
        _deviceId = widget.strDeviceId;
      }
      if (widget.strSN != null) {
        _sn = widget.strSN;
      }
      if (widget.strPN != null) {
        _pn = widget.strPN;
      }
      if (widget.str_selectedTypeId != null) {
        _selectedTypeId = widget.str_selectedTypeId;
        _selectedTypeName = widget.str_selectedTypeName;
      }
      if (widget.str_selectedModelId != null) {
        _selectedModelName = widget.str_selectedModelName;
        _selectedModelId = widget.str_selectedModelId;
      }
      if (widget.str_selectedEntityId != null) {
        _selectedEntityId = widget.str_selectedEntityId;
        _selectedEntityName = widget.str_selectedEntityName;
      }

      if (widget.str_selectedUser != null) {
        _selectedUser = widget.str_selectedUser;
        _selectedUserId = widget.str_selectedUserId;
      }
      if (widget.str_selectedLocation != null) {
        _selectedLocation = widget.str_selectedLocation;
        _selectedLocationId = widget.str_selectedLocationId;
      }
      if (widget.strPageIdentity != null) {
        _pageIdentity = widget.strPageIdentity;
      }
      print(_pageIdentity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Select User'),
        elevation: 0.0,
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    inputFormatters: [MyFormatter.UpperCaseFormatter()],
                    decoration: new InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },
                  ),
                ),
              ),
            ),
          ),
          new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? new ListView.builder(
                    itemCount: _searchResult.length,
                    itemBuilder: (context, i) {
                      return new Card(
                        child: new ExpansionTile(
                          leading: new Icon(
                            Icons.person_pin,
                            size: 40.0,
                            color: Colors.blue,
                          ),
                          title: new Text(
                            _searchResult[i].name,
                          ),
                          children: <Widget>[
                            new ListTile(
                              title: new Text(
                                '${_searchResult[i].firstname} ${_searchResult[i].lastname}',
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: new FlatButton(
                                child: new Text(
                                  'Select',
                                  style: new TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    _selectedUser = _searchResult[i].name;
                                    _selectedUserId = _searchResult[i].id;
                                  });
                                  if (_pageIdentity == "movementDevices") {
                                      setState(() {
                                      _pageIdentity = 'usersList';
                                    });
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                movementDevices
                                                    .MainMovementDevices(
                                                  str_selectedEntityId:
                                                      _selectedEntityId,
                                                  str_selectedEntityName:
                                                      _selectedEntityName,
                                                  str_selectedLocation:
                                                      _selectedLocation,
                                                  str_selectedLocationId:
                                                      _selectedLocationId,
                                                  str_selectedTypeName:
                                                      _selectedTypeName,
                                                  str_selectedUser:
                                                      _selectedUser,
                                                  str_selectedUserId:
                                                      _selectedUserId,
                                                  strDeviceId: _deviceId,
                                                  strPageIdentity:
                                                      _pageIdentity,
                                                )),
                                        );
                                  } else {
                                    Navigator.pop(context);

                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                addDevice.mainAdd(
                                                  strSN: _sn,
                                                  strPN: _pn,
                                                  strDeviceId: _deviceId,
                                                  str_selectedModelId:
                                                      _selectedModelId,
                                                  str_selectedEntityId:
                                                      _selectedEntityId,
                                                  str_selectedTypeId:
                                                      _selectedTypeId,
                                                  str_selectedModelName:
                                                      _selectedModelName,
                                                  str_selectedEntityName:
                                                      _selectedEntityName,
                                                  str_selectedTypeName:
                                                      _selectedTypeName,
                                                  str_selectedUserId:
                                                      _selectedUserId,
                                                  str_selectedUser:
                                                      _selectedUser,
                                                  str_selectedLocation:
                                                      _selectedLocation,
                                                  str_selectedLocationId:
                                                      _selectedLocationId,
                                                )),
                                        );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(0.0),
                      );
                    },
                  )
                : new ListView.builder(
                    itemCount: _userDetails.length,
                    itemBuilder: (context, index) {
                      return new Card(
                        child: new ExpansionTile(
                          leading: new Icon(
                            Icons.person_pin,
                            size: 40.0,
                            color: Colors.blue,
                          ),
                          title: new Text(_userDetails[index].name),
                          children: <Widget>[
                            new ListTile(
                              title: new Text(
                                '${_userDetails[index].firstname} ${_userDetails[index].lastname}',
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: new FlatButton(
                                child: new Text(
                                  'Select',
                                  style: new TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    _selectedUser = _userDetails[index].name;
                                    _selectedUserId = _userDetails[index].id;
                                  });
                                  if (_pageIdentity == "movementDevices") {
                                    setState(() {
                                      _pageIdentity = 'usersList';
                                    });
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                movementDevices
                                                    .MainMovementDevices(
                                                  str_selectedEntityId:
                                                      _selectedEntityId,
                                                  str_selectedEntityName:
                                                      _selectedEntityName,
                                                  str_selectedLocation:
                                                      _selectedLocation,
                                                  str_selectedLocationId:
                                                      _selectedLocationId,
                                                  str_selectedTypeName:
                                                      _selectedTypeName,
                                                  str_selectedUser:
                                                      _selectedUser,
                                                  str_selectedUserId:
                                                      _selectedUserId,
                                                  strDeviceId: _deviceId,
                                                  strPageIdentity:
                                                      _pageIdentity,
                                                )),);
                                  } else {
                                    Navigator.pop(context);

                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                addDevice.mainAdd(
                                                  strSN: _sn,
                                                  strPN: _pn,
                                                  strDeviceId: _deviceId,
                                                  str_selectedModelId:
                                                      _selectedModelId,
                                                  str_selectedEntityId:
                                                      _selectedEntityId,
                                                  str_selectedTypeId:
                                                      _selectedTypeId,
                                                  str_selectedModelName:
                                                      _selectedModelName,
                                                  str_selectedEntityName:
                                                      _selectedEntityName,
                                                  str_selectedTypeName:
                                                      _selectedTypeName,
                                                  str_selectedUserId:
                                                      _selectedUserId,
                                                  str_selectedUser:
                                                      _selectedUser,
                                                  str_selectedLocation:
                                                      _selectedLocation,
                                                  str_selectedLocationId:
                                                      _selectedLocationId,
                                                )),
                                      );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(0.0),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.id.contains(text) ||
          userDetail.name.contains(text) ||
          userDetail.firstname.contains(text) ||
          userDetail.lastname.contains(text)) _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

class MapIdName {
  //used by get selected type and selected model
  final String id, name, firstname, lastname;

  MapIdName({this.id, this.name, this.firstname, this.lastname});

  factory MapIdName.fromJson(Map<String, dynamic> json) {
    return new MapIdName(
      id: json['id'],
      name: json['name'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}
