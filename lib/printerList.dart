import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/Menu.dart' as menu;
import 'package:amds/printerDetails.dart' as printerDetails;
import 'package:amds/scanning.dart' as scanning;
import 'package:amds/utils/myClass.dart' as utils;

class HomePage extends StatefulWidget {
  String str_AppUsername;
  HomePage({this.str_AppUsername});
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _appUsername;

  TextEditingController controller = new TextEditingController();
  TextEditingController controller1 = new TextEditingController();

  List<MapIdNamePrinters> _searchPrinterResult = [];

  List<MapIdNamePrinters> _printerDetails = [];
  List<MapIdNamePrinters> _printerStates = [];
  List<DropdownMenuItem<String>> a = [];
  int _radiovalue = 1;
  String fullname, _selectedState = '';
  bool _result = false;

  String url = utils.defaultUrl + 'getPrinterList.php';

  // Get json result and convert it to model. Then add
  Future<Null> getPrinterDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map printer in responseJson) {
        _printerDetails.add(MapIdNamePrinters.fromJson(printer));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _appUsername = widget.str_AppUsername;
    a.add(new DropdownMenuItem(
      child: Text(
        'All',
        style: TextStyle(color: Colors.blue),
      ),
      value: '',
    ));
    a.add(new DropdownMenuItem(
      child: Text(
        'Active',
        style: TextStyle(color: Colors.green),
      ),
      value: '1',
    ));
    a.add(new DropdownMenuItem(
      child: Text(
        'On Service',
        style: TextStyle(color: Colors.amber),
      ),
      value: 'onservice',
    ));
    a.add(new DropdownMenuItem(
      child: Text(
        'Damaged',
        style: TextStyle(color: Colors.red),
      ),
      value: 'damaged',
    ));
    a.add(new DropdownMenuItem(
      child: Text(
        'Dispossed',
        style: TextStyle(color: Colors.grey),
      ),
      value: 'dispossed',
    ));
    getPrinterDetails().then((value) {
      setState(() {
        onSelectionStates('');
        _result = true;
      });
    });
    
  }

  void onSelectionStates(String value) {
    setState(() {
      _selectedState = value;

      switch (_selectedState) {
        case '':
          states_id('');
          break;
        case '1':
          states_id('1');
          break;

        case 'onservice':
          break;

        case 'damaged':
          break;

        case 'dispossed':
          print(_selectedState);
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
            title: new Text('Printer List'),
            elevation: 0.0,
            centerTitle: true,
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => scanning.scanning(
                            str_AppUsername: _appUsername,
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
                            items: a,
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
                ),)
                
              ])));
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Printer List'),
        elevation: 0.0,
        centerTitle: true,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => scanning.scanning(
                        str_AppUsername: _appUsername,
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
                        items: a,
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
            new Expanded(
              flex: 10,
              child: 
              
              _searchPrinterResult.length != 0 ||
                      controller.text.isNotEmpty
                  ? new ListView.builder(
                      padding: EdgeInsets.only(right: 10.0, left: 10.0),
                      itemCount: _searchPrinterResult.length,
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
                                            printerDetails.MainPrinterDetails(
                                              str_AppUsername: _appUsername,
                                              strPN:
                                                  _searchPrinterResult[i].pn,
                                              str_selectedTypeId:
                                                  _searchPrinterResult[i]
                                                      .typeId,
                                              str_selectedTypeName:
                                                  _searchPrinterResult[i]
                                                      .typeName,
                                              str_selectedEntityName:
                                                  _searchPrinterResult[i]
                                                      .entities,
                                              str_selectedEntityId:
                                                  _searchPrinterResult[i]
                                                      .entities_id,
                                              strSN:
                                                  _searchPrinterResult[i].sn,
                                              str_selectedLocation:
                                                  _searchPrinterResult[i]
                                                      .locations,
                                              str_selectedModelId:
                                                  _searchPrinterResult[i]
                                                      .modelId,
                                              str_selectedModelName:
                                                  _searchPrinterResult[i]
                                                      .modelName,
                                              strDeviceId:
                                                  _searchPrinterResult[i].name,
                                              str_selectedUser:
                                                  _searchPrinterResult[i]
                                                      .username,
                                              str_selectedUserId:
                                                  _searchPrinterResult[i]
                                                      .user_id,
                                              str_selectedLocationId:
                                                  _searchPrinterResult[i]
                                                      .locations_id,
                                            )));
                              },
                              leading:  new Icon(Icons.print),
                              title: new Text(_searchPrinterResult[i].name),
                              trailing: new Text(
                                  _searchPrinterResult[i].username,
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
                      itemCount: _printerDetails.length,
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
                                            printerDetails.MainPrinterDetails(
                                              str_AppUsername: _appUsername,
                                              str_selectedTypeName:
                                                  _printerDetails[index]
                                                      .typeName,
                                              str_selectedEntityName:
                                                  _printerDetails[index]
                                                      .entities,
                                              str_selectedEntityId:
                                                  _printerDetails[index]
                                                      .entities_id,
                                              strSN: _printerDetails[index].sn,
                                              str_selectedLocation:
                                                  _printerDetails[index]
                                                      .locations,
                                              str_selectedModelName:
                                                  _printerDetails[index]
                                                      .modelName,
                                              strDeviceId:
                                                  _printerDetails[index].name,
                                              str_selectedUser:
                                                  _printerDetails[index]
                                                      .username,
                                              str_selectedUserId:
                                                  _printerDetails[index]
                                                      .user_id,
                                              str_selectedLocationId:
                                                  _printerDetails[index]
                                                      .locations_id,
                                              str_selectedModelId:
                                                  _printerDetails[index]
                                                      .modelId,
                                              str_selectedTypeId:
                                                  _printerDetails[index]
                                                      .typeId,
                                              strPN: _printerDetails[index].pn,
                                            )));
                              },
                              leading:new Icon(Icons.print),
                              title: new Text(_printerDetails[index].name),
                              trailing: new Text(
                                _printerDetails[index].username,
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold),
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
//original modified
  // onSearchTextChanged(String text, String states_id) async {
  //   _searchPrinterResult.clear();
  //   if (text.isEmpty && states_id == '0') {
  //     setState(() {});
  //     return;
  //   }

  //   _printerDetails.forEach((printerDetail) {
  //     if (
  //         printerDetail.name.contains(text)||
  //         printerDetail.username.contains(text)||
  //         printerDetail.lastname.contains(text)||
  //         printerDetail.firstname.contains(text)||
  //         printerDetail.states_id.contains('1'))
  //       _searchPrinterResult.add(printerDetail);
  //       print(_searchPrinterResult.length);
  //   });

  //   setState(() {});
  // }

//trial
  onSearchTextChanged(String text) async {
    _searchPrinterResult.clear();

    if (_selectedState == '' && text.isEmpty) {
      setState(() {});
      return;
    }

    _printerDetails.forEach((printerDetail) {
      if (printerDetail.states_id.contains(_selectedState) &&
              printerDetail.name.contains(text) ||
          printerDetail.states_id.contains(_selectedState) &&
              printerDetail.username.contains(text) ||
          printerDetail.states_id.contains(_selectedState) &&
              printerDetail.lastname.contains(text) ||
          printerDetail.states_id.contains(_selectedState) &&
              printerDetail.firstname.contains(text)) {
        _searchPrinterResult.add(printerDetail);
      }
      print(_searchPrinterResult.length);
    });

    setState(() {});
  }

  states_id(String states_id) async {
    _searchPrinterResult.clear();
    if (states_id.isEmpty) {
      setState(() {});
      print(_searchPrinterResult.length);

      return;
    }

    _printerDetails.forEach((printerDetail) {
      if (printerDetail.states_id.contains(states_id))
        _searchPrinterResult.add(printerDetail);
      print(_searchPrinterResult.length);
    });

    setState(() {});
  }
}

class MapIdNamePrinters {
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
      states_id;

  MapIdNamePrinters(
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
      this.states_id});

  factory MapIdNamePrinters.fromJson(Map<String, dynamic> json) {
    return new MapIdNamePrinters(
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
        states_id: json['states_id']);
  }
}
