import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/Menu.dart' as menu;
import 'package:amds/movementDevices.dart' as movementDevices;
import 'package:amds/utils/myClass.dart' as utils;

class MainDeviceDetails extends StatefulWidget {
  String strdeviceType,
      strDeviceId,
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
      str_deviceStatesId,
      str_deviceStatesName;

  MainDeviceDetails(
      {this.strdeviceType,
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
      this.str_deviceStatesId,
      this.str_deviceStatesName});
  @override
  _MainDeviceDetailsState createState() => _MainDeviceDetailsState();
}

class _MainDeviceDetailsState extends State<MainDeviceDetails> {
  String _deviceType,
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
      _sn,
      _pn,
      _appUsername,
      _deviceStatesId,
      _deviceStatesName,
      url = utils.defaultUrl;
  List<MapDeviceHistory> _deviceDetails = [];
  Icon _icon;
  bool _result = false;

  Color statusColor;
  @override
  Widget build(BuildContext context) {
    if (_result == false) {
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
                Tab(icon: Icon(Icons.history), text: "History (0)"),
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
                  label: Text('Edit'),
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                movementDevices.MainMovementDevices(
                                  strdeviceType: _deviceType,
                                  str_AppUsername: _appUsername,
                                  str_selectedTypeName: _selectedTypeName,
                                  str_selectedLocationId: _selectedLocationId,
                                  str_selectedUserId: _selectedUserId,
                                  str_selectedEntityId: _selectedEntityId,
                                  str_selectedEntityName: _selectedEntityName,
                                  str_selectedLocation: _selectedLocation,
                                  strDeviceId: _deviceId,
                                  str_selectedUser: _selectedUser,
                                  str_deviceStatesId: _deviceStatesId,
                                  str_deviceStatesName: _deviceStatesName,
                                )));
                  },
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
                        new Center(child: _icon),
                        new ListTile(
                          leading: new Text('USERNAME'),
                          title: new Text(':'),
                          trailing: Text(_selectedUser.toString(),
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        new ListTile(
                          leading: new Text('ENTITIES'),
                          title: new Text(':'),
                          trailing: Text(_selectedEntityName.toString(),
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        new ListTile(
                          leading: new Text('LOCATION'),
                          title: new Text(':'),
                          trailing: Text(_selectedLocation.toString(),
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        new ListTile(
                          leading: new Text('TYPE'),
                          title: new Text(':'),
                          trailing: Text(_selectedTypeName.toString(),
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                        ),
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
                          trailing: Text(_deviceStatesName.toString(),
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: statusColor)),
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
              Container(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.warning,
                      size: 80.0,
                    ),
                    Text('Nothing Found')
                  ],
                ),
              )
            ],
          ),
        ),
      );
    } else {
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
                Tab(
                    icon: Icon(Icons.history),
                    text: "History (" + _deviceDetails[0].historyCounter + ")"),
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
                  label: Text('Edit'),
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                movementDevices.MainMovementDevices(
                                  strdeviceType: _deviceType,
                                  str_AppUsername: _appUsername,
                                  str_selectedTypeName: _selectedTypeName,
                                  str_selectedLocationId: _selectedLocationId,
                                  str_selectedUserId: _selectedUserId,
                                  str_selectedEntityId: _selectedEntityId,
                                  str_selectedEntityName: _selectedEntityName,
                                  str_selectedLocation: _selectedLocation,
                                  strDeviceId: _deviceId,
                                  str_selectedUser: _selectedUser,
                                  str_deviceStatesId: _deviceStatesId,
                                  str_deviceStatesName: _deviceStatesName,
                                )));
                  },
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
                        new Center(child: _icon),
                        new ListTile(
                          leading: new Text('USERNAME'),
                          title: new Text(':'),
                          trailing: Text(_selectedUser.toString(),
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        new ListTile(
                          leading: new Text('ENTITIES'),
                          title: new Text(':'),
                          trailing: Text(_selectedEntityName.toString(),
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        new ListTile(
                          leading: new Text('LOCATION'),
                          title: new Text(':'),
                          trailing: Text(_selectedLocation.toString(),
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        new ListTile(
                          leading: new Text('TYPE'),
                          title: new Text(':'),
                          trailing: Text(_selectedTypeName.toString(),
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                        ),
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
                          trailing: Text(_deviceStatesName.toString(),
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: statusColor)),
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
              new ListView.builder(
                  padding: EdgeInsets.only(
                    right: 5.0,
                    left: 5.0,
                  ),
                  itemCount: _deviceDetails.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: EdgeInsets.only(bottom: 2.0),
                        child: new ExpansionTile(
                          backgroundColor: Colors.black45,
                          leading: new Text(_deviceDetails[index].date_mod.substring(0,16)),
                          title: new Text(
                              'By :' + _deviceDetails[index].user_name,style: TextStyle(fontSize: 15.0),),
                          children: <Widget>[
                            Text("BEFORE :"),
                            Text(_deviceDetails[index].old_value,
                                textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                            ),
                            Text("AFTER :",),
                            Text(
                              _deviceDetails[index].new_value,
                              textAlign: TextAlign.center,style: TextStyle(color: Colors.green)
                            )
                          ],
                        ));
                  }),
            ],
          ),
        ),
      );
    }
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
      if (widget.str_deviceStatesId != null) {
        _deviceStatesId = widget.str_deviceStatesId;
        _deviceStatesName = widget.str_deviceStatesName;
        if (_deviceStatesName == "USED") {
          statusColor = Colors.green;
        } else if (_deviceStatesName == "DAMAGED") {
          statusColor = Colors.red;
        } else if (_deviceStatesName == "SPARE") {
          statusColor = Colors.cyan;
        }
      }
      if (widget.strdeviceType != null) {
        _deviceType = widget.strdeviceType.toUpperCase();
        if (_deviceType == "COMPUTERS") {
          _selectedTypeName == 'DESKTOP'
              ? _icon = new Icon(
                  Icons.desktop_mac,
                  size: 80.0,
                )
              : _selectedTypeName == 'NOTEBOOK'
                  ? _icon = new Icon(
                      Icons.laptop,
                      size: 80.0,
                    )
                  : _icon = new Icon(
                      Icons.close,
                      size: 80.0,
                    );
        } else if (_deviceType == "PRINTERS") {
          _icon = new Icon(
            Icons.print,
            size: 80.0,
          );
        }
      }
      _appUsername = widget.str_AppUsername;

      getDeviceHistory(_deviceType, _deviceId).then((onValue) {
        if (_deviceDetails.length == 0) {
        } else {
          setState(() {
            _result = true;
          });
        }
      });
    });
  }

  Future getDeviceHistory(String deviceType, String deviceName) async {
    String result;

    final response = await http.post(url + 'getDeviceHistory.php', body: {
      'devicetype': deviceType,
      'devicename': deviceName,
    }).then((onValue) {
      final jsonValue = json.decode(onValue.body);
      for (Map i in jsonValue) {
        _deviceDetails.add(MapDeviceHistory.fromJson(i));
      }
    });
  }
}

class MapDeviceHistory {
  final String id,
      itemtype,
      items_id,
      user_name,
      date_mod,
      old_value,
      new_value,
      historyCounter;

  MapDeviceHistory({
    this.id,
    this.itemtype,
    this.items_id,
    this.user_name,
    this.date_mod,
    this.old_value,
    this.new_value,
    this.historyCounter,
  });

  factory MapDeviceHistory.fromJson(Map<String, dynamic> json) {
    return new MapDeviceHistory(
      id: json['id'],
      itemtype: json['itemtype'],
      items_id: json['items_id'],
      user_name: json['user_name'],
      date_mod: json['date_mod'],
      old_value: json['old_value'],
      new_value: json['new_value'],
      historyCounter: json['historyCounter'],
    );
  }
}
