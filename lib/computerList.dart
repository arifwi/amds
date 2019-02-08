import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/Menu.dart' as menu;
import 'package:amds/deviceDetails.dart' as deviceDetails;
import 'package:amds/scanning.dart' as scanning;
import 'package:amds/utils/myClass.dart' as utils;

class HomePage extends StatefulWidget {
  String str_AppUsername;
  HomePage({this.str_AppUsername});
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _appUsername, _deviceType = "COMPUTERS";

  TextEditingController controller = new TextEditingController();
  TextEditingController controller1 = new TextEditingController();

  List<MapIdNameComputers> _searchComputerResult = [];

  List<MapIdNameComputers> _computerDetails = [];
  List<MapIdNameComputers> _computerStates = [];
  List<DropdownMenuItem<String>> list_state = [];
  int _radiovalue = 1;
  String fullname, _selectedState = '', computerCounter = '-';
  bool _result = false;

  String url = utils.defaultUrl + 'getComputerList.php';

  // Get json result and convert it to model. Then add
  Future<Null> getComputerDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map computer in responseJson) {
        _computerDetails.add(MapIdNameComputers.fromJson(computer));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _appUsername = widget.str_AppUsername;
    print(_deviceType);
    print(_appUsername);
    list_state.add(new DropdownMenuItem(
      child: Text(
        'All',
        style: TextStyle(color: Colors.blue),
      ),
      value: '',
    ));
    list_state.add(new DropdownMenuItem(
      child: Text(
        'Active',
        style: TextStyle(color: Colors.green),
      ),
      value: '1',
    ));
    list_state.add(new DropdownMenuItem(
      child: Text(
        'Spare',
        style: TextStyle(color: Colors.cyan),
      ),
      value: '2',
    ));
    list_state.add(new DropdownMenuItem(
      child: Text(
        'On Service',
        style: TextStyle(color: Colors.amber),
      ),
      value: '4',
    ));
    list_state.add(new DropdownMenuItem(
      child: Text(
        'Damaged',
        style: TextStyle(color: Colors.red),
      ),
      value: '3',
    ));
    list_state.add(new DropdownMenuItem(
      child: Text(
        'Dispossed',
        style: TextStyle(color: Colors.grey),
      ),
      value: '5',
    ));
    getComputerDetails().then((value) {
      setState(() {
        onSelectionStates('');
        _result = true;
        print(_computerDetails[0].states_name);
        computerCounter = _computerDetails.length.toString();
      });
    });
  }

  Future<Null> onSelectionStates(String value) async {
    setState(() {
      _selectedState = value;

      switch (_selectedState) {
        case '':
          states_id('').then((onValue) {
            computerCounter = _computerDetails.length.toString();
          });

          break;
        case '1':
          states_id('1').then((onValue) {
            computerCounter = _searchComputerResult.length.toString();
          });
          break;

        case '2':
          states_id('2').then((onValue) {
            computerCounter = _searchComputerResult.length.toString();
          });
          break;

        case '4':
          states_id('4').then((onValue) {
            computerCounter = _searchComputerResult.length.toString();
          });
          break;

        case '3':
          states_id('3').then((onValue) {
            computerCounter = _searchComputerResult.length.toString();
          });
          break;

        case '5':
          states_id('5').then((onValue) {
            computerCounter = _searchComputerResult.length.toString();
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_result == false) {
      //Lakukan sesuatu sambil menunggu proses get dari database
      return Scaffold(
          appBar: new AppBar(
            title: new Text('Computer List'),
            elevation: 0.0,
            actions: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 15.0, top: 20.0),
                child: Text("Counter : $computerCounter"),
              )
            ],
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => scanning.MainScanning(
                            str_AppUsername: _appUsername,
                            strdeviceType: _deviceType,
                          )));
            },
            child: new Icon(Icons.add),
          ),
          body: Container(
              color: Theme.of(context).primaryColor,
              child: new Column(children: <Widget>[
                new Container(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: new Card(
                      child: new ListTile(
                        leading: new Icon(Icons.sort),
                        title: new Text('Sort By'),
                        trailing: new DropdownButtonHideUnderline(
                          child: new DropdownButton(
                            items: list_state,
                            value: _selectedState,
                            onChanged: (value) {
                              onSelectionStates(value);
                            },
                          ),
                        ),
                        // trailing: new IconButton(
                        //   icon: new Icon(Icons.cancel),
                        //   onPressed: () {
                        //     controller.clear();
                        //     states_id(controller1.text);
                        //   },
                        // ),
                      ),
                    ),
                  ),
                ),
                new Container(
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
                          onChanged: (value) {
                            onSearchTextChanged(controller.text);
                          },
                        ),
                        trailing: new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            controller.text = '';
                            onSearchTextChanged('');
                            states_id(_selectedState);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                new Container(
                  child: new LinearProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              ])));
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Computer List'),
        elevation: 0.0,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 15.0, top: 20.0),
            child: Text("Counter : $computerCounter"),
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => scanning.MainScanning(
                        str_AppUsername: _appUsername,
                        strdeviceType: _deviceType,
                      )));
        },
        child: new Icon(Icons.add),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: new Column(
          children: <Widget>[
            new Container(
              child: new Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: new Card(
                  child: new ListTile(
                    leading: new Icon(Icons.sort),
                    title: new Text('Sort By'),
                    trailing: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        items: list_state,
                        value: _selectedState,
                        onChanged: (value) {
                          onSelectionStates(value);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            new Container(
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
                      onChanged: (value) {
                        onSearchTextChanged(controller.text);
                      },
                    ),
                    trailing: new IconButton(
                      icon: new Icon(Icons.cancel),
                      onPressed: () {
                        controller.text = '';
                        onSearchTextChanged('');
                        states_id(_selectedState);
                      },
                    ),
                  ),
                ),
              ),
            ),
            new Expanded(
              flex: 10,
              child: computerCounter == "0"
                  ? new Column(
                      children: <Widget>[
                        new Icon(
                          Icons.report_problem,
                          size: 80.0,
                        ),
                        new Text("Nothing Found")
                      ],
                    )
                  : _searchComputerResult.length != 0 ||
                          controller.text.isNotEmpty
                      ? new ListView.builder(
                          padding: EdgeInsets.only(right: 10.0, left: 10.0),
                          itemCount: _searchComputerResult.length,
                          itemBuilder: (context, i) {
                            return Container(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: new Card(
                                child: new ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                deviceDetails.MainDeviceDetails(
                                                  strdeviceType: "COMPUTERS",
                                                  str_deviceStatesId:
                                                      _searchComputerResult[i]
                                                          .states_id,
                                                  str_deviceStatesName:
                                                      _searchComputerResult[i]
                                                          .states_name,
                                                  str_AppUsername: _appUsername,
                                                  strPN:
                                                      _searchComputerResult[i]
                                                          .pn,
                                                  str_selectedTypeId:
                                                      _searchComputerResult[i]
                                                          .typeId,
                                                  str_selectedTypeName:
                                                      _searchComputerResult[i]
                                                          .typeName,
                                                  str_selectedEntityName:
                                                      _searchComputerResult[i]
                                                          .entities,
                                                  str_selectedEntityId:
                                                      _searchComputerResult[i]
                                                          .entities_id,
                                                  strSN:
                                                      _searchComputerResult[i]
                                                          .sn,
                                                  str_selectedLocation:
                                                      _searchComputerResult[i]
                                                          .locations,
                                                  str_selectedModelId:
                                                      _searchComputerResult[i]
                                                          .modelId,
                                                  str_selectedModelName:
                                                      _searchComputerResult[i]
                                                          .modelName,
                                                  strDeviceId:
                                                      _searchComputerResult[i]
                                                          .name,
                                                  str_selectedUser:
                                                      _searchComputerResult[i]
                                                          .username,
                                                  str_selectedUserId:
                                                      _searchComputerResult[i]
                                                          .user_id,
                                                  str_selectedLocationId:
                                                      _searchComputerResult[i]
                                                          .locations_id,
                                                )));
                                  },
                                  leading: _searchComputerResult[i].typeName ==
                                          'NOTEBOOK'
                                      ? new Icon(Icons.laptop)
                                      : new Icon(Icons.desktop_mac),
                                  title:
                                      new Text(_searchComputerResult[i].name),
                                  trailing: new Text(
                                      _searchComputerResult[i].username,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                margin: const EdgeInsets.all(0.0),
                              ),
                            );
                          },
                        )
                      : new ListView.builder(
                          padding: EdgeInsets.only(
                            right: 10.0,
                            left: 10.0,
                          ),
                          itemCount: _computerDetails.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: new Card(
                                child: new ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                deviceDetails.MainDeviceDetails(
                                                  strdeviceType: "COMPUTERS",
                                                  str_AppUsername: _appUsername,
                                                  str_deviceStatesId:
                                                      _computerDetails[index]
                                                          .states_id,
                                                  str_deviceStatesName:
                                                      _computerDetails[index]
                                                          .states_name,
                                                  str_selectedTypeName:
                                                      _computerDetails[index]
                                                          .typeName,
                                                  str_selectedEntityName:
                                                      _computerDetails[index]
                                                          .entities,
                                                  str_selectedEntityId:
                                                      _computerDetails[index]
                                                          .entities_id,
                                                  strSN: _computerDetails[index]
                                                      .sn,
                                                  str_selectedLocation:
                                                      _computerDetails[index]
                                                          .locations,
                                                  str_selectedModelName:
                                                      _computerDetails[index]
                                                          .modelName,
                                                  strDeviceId:
                                                      _computerDetails[index]
                                                          .name,
                                                  str_selectedUser:
                                                      _computerDetails[index]
                                                          .username,
                                                  str_selectedUserId:
                                                      _computerDetails[index]
                                                          .user_id,
                                                  str_selectedLocationId:
                                                      _computerDetails[index]
                                                          .locations_id,
                                                  str_selectedModelId:
                                                      _computerDetails[index]
                                                          .modelId,
                                                  str_selectedTypeId:
                                                      _computerDetails[index]
                                                          .typeId,
                                                  strPN: _computerDetails[index]
                                                      .pn,
                                                )));
                                  },
                                  leading: _computerDetails[index].typeName ==
                                          'NOTEBOOK'
                                      ? new Icon(Icons.laptop)
                                      : new Icon(Icons.desktop_mac),
                                  title: new Text(_computerDetails[index].name),
                                  trailing: new Text(
                                    _computerDetails[index].username,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                margin: const EdgeInsets.all(0.0),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> onSearchTextChanged(String text) async {
    _searchComputerResult.clear();

    if (_selectedState == '' && text.isEmpty) {
      setState(() {
        computerCounter = _computerDetails.length.toString();
      });
      return;
    }

    _computerDetails.forEach((computerDetail) {
      if (computerDetail.states_id.contains(_selectedState) &&
              computerDetail.name.contains(text) ||
          computerDetail.states_id.contains(_selectedState) &&
              computerDetail.username.contains(text) ||
          computerDetail.states_id.contains(_selectedState) &&
              computerDetail.lastname.contains(text) ||
          computerDetail.states_id.contains(_selectedState) &&
              computerDetail.firstname.contains(text)) {
        _searchComputerResult.add(computerDetail);
      }
    });

    setState(() {
      computerCounter = _searchComputerResult.length.toString();
    });
  }

  Future<Null> states_id(String states_id) async {
    _searchComputerResult.clear();
    if (states_id.isEmpty) {
      setState(() {});
      print(_searchComputerResult.length);

      return;
    }

    _computerDetails.forEach((computerDetail) {
      if (computerDetail.states_id.contains(states_id))
        _searchComputerResult.add(computerDetail);
      print(_searchComputerResult.length);
    });

    setState(() {});
  }
}

class MapIdNameComputers {
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

  MapIdNameComputers(
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

  factory MapIdNameComputers.fromJson(Map<String, dynamic> json) {
    return new MapIdNameComputers(
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
