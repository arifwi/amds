import 'dart:async';
import 'dart:convert';
import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/Menu.dart' as menu;
import 'package:amds/usersList.dart' as UsersList;

class MainMovementDevices extends StatefulWidget {
  String strDeviceId,
      str_selectedEntityId,
      str_selectedTypeName,
      str_selectedEntityName,
      str_selectedUser,
      str_selectedLocation,
      str_selectedUserId,
      str_selectedLocationId,
      strPageIdentity;

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
      _pageIdentity;

  String url = 'http://192.168.43.62/amdsweb/';
  List<DropdownMenuItem<String>> dataEntities = [];
  List<MapIdName> _listDataEntities = [];
  List<MapIdName> _searchEntitiesResult = [];

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
          ? new Stack(children: <Widget>[
              ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: new Center(
                        child: new Text(
                      'CURRENT DETAILS',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.red),
                    )),
                  ),
                  new ListTile(
                    leading: new Text('USERNAME'),
                    title: new Text(':'),
                    trailing: Text(_selectedUser.toString(),
                        style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                  ),
                  new ListTile(
                    leading: new Text('ENTITIES'),
                    title: new Text(':'),
                    trailing: Text(_selectedEntityName.toString(),
                        style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.amber)),
                  ),
                  new ListTile(
                    leading: new Text('LOCATION'),
                    title: new Text(':'),
                    trailing: Text(_selectedLocation.toString(),
                        style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.amber)),
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
                      label: new Text('MOVE'),
                    ),
                  ),
                ],
              ),
            ])
          : 
          new Stack(children: <Widget>[
              ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: new Center(
                        child: new Text(
                      'MOVE TO:',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.red),
                    )),
                  ),
                  new ListTile(
                    leading: new Text('USERNAME'),
                    title: new Text(':'),
                    
                  ),
                  new ListTile(
                        leading:  _selectedLocation == null
                            ? new Text('')
                            : new Text(
                                _selectedUser.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.amber),
                              ),
                        trailing: new IconButton(
                          icon: new Icon(Icons.search),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              _pageIdentity = 'movementDevices';

                            });
                            _navigateAndDisplaySelection(context);
                            print(LocalHistoryRoute);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => UsersList.HomePage(
                            //             strDeviceId: _deviceId,
                            //             str_selectedEntityId: _selectedEntityId,
                            //             str_selectedEntityName:
                            //                 _selectedEntityName,
                            //             str_selectedTypeName: _selectedTypeName,
                            //             str_selectedUserId: _selectedUserId,
                            //             str_selectedUser: _selectedUser,
                            //             str_selectedLocation: _selectedLocation,
                            //             str_selectedLocationId:
                            //                 _selectedLocationId,
                            //                 strPageIdentity: _pageIdentity,
                            //           )));
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
                            style:
                                TextStyle(fontSize: 17.0, color: Colors.black),
                            value: _selectedEntityId,
                            items: dataEntities,
                            hint: Text('Select Entitiy'),
                            onChanged: (value) {
                              setState(() {
                                _searchEntitiesResult = [];

                                _selectedEntityId = value;
                                _listDataEntities.forEach((MapTypeModel) {
                                  if (MapTypeModel.id
                                      .contains(_selectedEntityId))
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
                    
                        leading:  _selectedLocation == null
                            ? new Text('')
                            : new Text(_selectedLocation.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.amber),),
                        trailing: new IconButton(
                          icon: new Icon(Icons.search),
                          color: Colors.blue,
                          onPressed: () {},
                        ),
                      ),
                  Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child:  new RaisedButton.icon(
                    color: Colors.blue,
                    icon: new Icon(Icons.save),
                    onPressed: () {
                      setState(() {
                        unmove = true;
                      });
                    },
                    label: new Text('SAVE'),
                  
                    ),
                  ),
                ],
              ),
            ])
          
    );
  }

  _navigateAndDisplaySelection(BuildContext dynamic) async {
    // Navigator.push returns a Future that will complete after we call
    // Navigator.pop on the Selection Screen!
    final result = await Navigator.push(
      context,
      // We'll create the SelectionScreen in the next step!
      
      MaterialPageRoute(builder: (context) =>UsersList.HomePage(
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
                                      print(result);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
        if(widget.strPageIdentity != null){
          if(widget.strPageIdentity == 'userList'){
            _pageIdentity = widget.strPageIdentity;
            unmove = false;
          }
         
        }
        
        print(_selectedEntityId);
        print(_selectedTypeName);
        print(_selectedEntityName);
        print(_selectedUser);
        print(_selectedUserId);
        print(_selectedLocation);
        print(_selectedLocationId);
        print(_deviceId);
      });
    });
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
