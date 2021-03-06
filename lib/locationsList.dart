import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/movementDevices.dart' as movementDevices;
import 'package:amds/utils/myClass.dart' as utils;

class HomePage extends StatefulWidget {
  String strPN,
      strSN,
      strdeviceType,
      strDeviceId,
      str_selectedModelId,
      str_selectedModelName,
      str_selectedEntityId,
      str_selectedTypeName,
      str_selectedTypeId,
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

  HomePage({
    this.strSN,
    this.strPN,
    this.strdeviceType,
    this.strDeviceId,
    this.str_selectedModelId,
    this.str_selectedModelName,
    this.str_selectedEntityId,
    this.str_selectedTypeName,
    this.str_selectedTypeId,
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
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _sn,
      _pn,
      _deviceType,
      _selectedTypeId,
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
      _pageIdentity,
      _appUsername,
      _current_locationname,
      _current_username,
      _current_entityname,
      _current_statesname,
      _deviceStatesName,
      _deviceStatesId;

  TextEditingController controller = new TextEditingController();

  List<MapIdName> _searchResult = [];

  List<MapIdName> _locationDetails = [];

  String fullname;

  String url = utils.defaultUrl + 'getLocations.php';

  // Get json result and convert it to model. Then add
  Future<Null> getLocation() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _locationDetails.add(MapIdName.fromJson(user));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getLocation().then((result) {
      _appUsername = widget.str_AppUsername;
      _deviceType =widget.strdeviceType;
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
      }
      if (widget.str_selectedTypeName != null) {
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
      if (widget.str_deviceStatesId != null) {
        _deviceStatesId = widget.str_deviceStatesId;
        _deviceStatesName = widget.str_deviceStatesName;
      }
      if (widget.str_current_entityname != null ||
          widget.str_current_locationname != null ||
          widget.str_current_username != null ||
          widget.str_current_states != null) {
        _current_entityname = widget.str_current_entityname.toUpperCase();
        _current_locationname = widget.str_current_locationname.toUpperCase();
        _current_username = widget.str_current_username.toUpperCase();
        _current_statesname = widget.str_current_states.toUpperCase();
      }
      if (widget.strdeviceType != null) {
        _deviceType = widget.strdeviceType.toUpperCase();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Select Location'),
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
                            Icons.location_on,
                            size: 40.0,
                            color: Colors.blue,
                          ),
                          title: new Text(
                            _searchResult[i].name,
                          ),
                          children: <Widget>[
                            new ListTile(
                              title: new Text(
                                '${_searchResult[i].id} ${_searchResult[i].name}',
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
                                    _selectedLocation = _searchResult[i].name;
                                    _selectedLocationId = _searchResult[i].id;
                                  });
                                  if (_pageIdentity == "movementDevices") {
                                    setState(() {
                                      _pageIdentity = 'locationsList';
                                    });
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => movementDevices
                                                  .MainMovementDevices(
                                                    strdeviceType: _deviceType,
                                                    str_AppUsername: _appUsername,
                                                str_deviceStatesId:
                                                    _deviceStatesId,
                                                str_deviceStatesName:
                                                    _deviceStatesName,
                                                str_current_states:
                                                    _current_statesname,
                                                str_current_entityname:
                                                    _current_entityname,
                                                str_current_locationname:
                                                    _current_locationname,
                                                str_current_username:
                                                    _current_username,
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
                                                str_selectedUser: _selectedUser,
                                                str_selectedUserId:
                                                    _selectedUserId,
                                                strDeviceId: _deviceId,
                                                strPageIdentity: _pageIdentity,
                                              )),
                                    );
                                  } else {
                                    Navigator.pop(context);

                                    Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              addDevice.mainAdd(
                                                strdeviceType: _deviceType,
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
                                                str_selectedUser: _selectedUser,
                                                str_selectedLocation:
                                                    _selectedLocation,
                                                str_selectedLocationId:
                                                    _selectedLocationId,
                                                str_AppUsername: _appUsername,
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
                    itemCount: _locationDetails.length,
                    itemBuilder: (context, index) {
                      return new Card(
                        child: new ExpansionTile(
                          leading: new Icon(
                            Icons.location_on,
                            size: 40.0,
                            color: Colors.blue,
                          ),
                          title: new Text(_locationDetails[index].name),
                          children: <Widget>[
                            new ListTile(
                              title: new Text(
                                '${_locationDetails[index].id} ${_locationDetails[index].name}',
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
                                    _selectedLocation =
                                        _locationDetails[index].name;
                                    _selectedLocationId =
                                        _locationDetails[index].id;
                                  });
                                  if (_pageIdentity == "movementDevices") {
                                    setState(() {
                                      _pageIdentity = 'locationsList';
                                    });
                                    //print(_pageIdentity);
                                    //Navigator.pop(context,_selectedUser);
                                    Navigator.pop(context);

                                    Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => movementDevices
                                                  .MainMovementDevices(
                                                    strdeviceType: _deviceType,
                                                    str_AppUsername: _appUsername,
                                                str_deviceStatesId:
                                                    _deviceStatesId,
                                                str_deviceStatesName:
                                                    _deviceStatesName,
                                                str_current_states:
                                                    _current_statesname,
                                                str_current_entityname:
                                                    _current_entityname,
                                                str_current_locationname:
                                                    _current_locationname,
                                                str_current_username:
                                                    _current_username,
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
                                                str_selectedUser: _selectedUser,
                                                str_selectedUserId:
                                                    _selectedUserId,
                                                strDeviceId: _deviceId,
                                                strPageIdentity: _pageIdentity,
                                              )),
                                    );
                                  } else {
                                    Navigator.pop(context);

                                    Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              addDevice.mainAdd(
                                                strdeviceType: _deviceType,
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
                                                str_selectedUser: _selectedUser,
                                                str_selectedLocation:
                                                    _selectedLocation,
                                                str_selectedLocationId:
                                                    _selectedLocationId,
                                                str_AppUsername: _appUsername,
                                              )),
                                    );
                                    //print(_selectedLocation+''+_selectedLocationId);
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

    _locationDetails.forEach((locationDetail) {
      if (locationDetail.id.contains(text) ||
          locationDetail.name.contains(text)) _searchResult.add(locationDetail);
    });

    setState(() {});
  }
}

class MapIdName {
  //used by get selected type and selected model
  final String id, name;

  MapIdName({this.id, this.name});

  factory MapIdName.fromJson(Map<String, dynamic> json) {
    return new MapIdName(
      id: json['id'],
      name: json['name'],
    );
  }
}
