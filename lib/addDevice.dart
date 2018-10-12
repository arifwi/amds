import 'dart:async';
import 'dart:convert';

import 'package:amds/Menu.dart' as menu;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_permissions/simple_permissions.dart';
import 'package:amds/scanning.dart' as scan;
import 'package:amds/usersList.dart' as UsersList;
import 'package:amds/locationsList.dart' as LocationList;
import 'package:amds/utils/formatter.dart' as MyFormatter;

class mainAdd extends StatefulWidget {
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
      str_selectedLocationId;

  mainAdd({
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
  });

  @override
  mainAddState createState() {
    return new mainAddState();
  }
}

class mainAddState extends State<mainAdd> with SingleTickerProviderStateMixin {
  //String url = 'http://192.168.43.62/amdsweb/';
  String url = 'http://172.28.16.84:8089/';

  Permission permission = Permission.Camera;

  TextEditingController controllerDeviceId = new TextEditingController();
  TextEditingController controllerSerialNumber = new TextEditingController();
  TextEditingController controllerProductNumber = new TextEditingController();

  FocusNode fDeviceId = new FocusNode();
  FocusNode fSerialNumber = new FocusNode();
  FocusNode fProductNumber = new FocusNode();

  bool enableDeviceID = true, enableSN = true, enablePN = true;

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
      _pn;

  List<DropdownMenuItem<String>> dataType = [];
  List<DropdownMenuItem<String>> dataModel = [];
  List<DropdownMenuItem<String>> dataEntities = [];

  //List<UserDetails> txtselectedType, txtselectedModel;
  List<MapIdName> _listDataType = [];
  List<MapIdName> _searchTypeResult = [];
  List<MapIdName> _listDataModel = [];
  List<MapIdName> _searchModelResult = [];
  List<MapIdName> _listDataEntities = [];
  List<MapIdName> _searchEntitiesResult = [];

  String isSuccessInput;

  var _result;

  String qresult = '';

  bool _isUnlock = true;
  Icon iconLock = new Icon(Icons.lock);
  Icon iconLockOpen = new Icon(Icons.lock_open);

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    getcomputerTypes().then((result) {
      new Future.delayed(Duration(milliseconds: 250), () {
        _result = result;
        getcomputerModels().then((result) {
          getEntities().then((result) {
            setState(() {
              if (widget.strDeviceId != null) {
                _deviceId = widget.strDeviceId;
                controllerDeviceId.text = _deviceId;
                _isUnlock = false;
                enableDeviceID = false;

              }
              if (widget.strSN != null) {
                _sn = widget.strSN;
                controllerSerialNumber.text = _sn;
                _isUnlock = false;
               enableSN = false;
              }
              if (widget.strPN != null) {
                _pn = widget.strPN;
                controllerProductNumber.text = _pn;
                _isUnlock = false;
                enablePN = false;

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
            });
          });
        });
      });
    });
  }

//INTERFACE//
  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      //Lakukan sesuatu sambil menunggu proses get dari database

      return new Scaffold(
          appBar: new AppBar(),
          body: new Container(
            child: new LinearProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ));
    }

    return WillPopScope(
      onWillPop: backButtonDialog,
      child: Scaffold(
        appBar: new AppBar(
          title: Text('Add Device'),
          leading: new Icon(Icons.add_to_queue),
          actions: <Widget>[
            new IconButton(
              icon: _isUnlock == true ? iconLockOpen : iconLock,
              onPressed: () {
                setState(() {
                  if (_isUnlock == true) {
                    _isUnlock = false;
                    enableDeviceID = false;
                    enablePN = false;
                    enableSN = false;
                  } else {
                    _isUnlock = true;
                    enableDeviceID = true;
                    enablePN = true;
                    enableSN = true;
                  }
                });
              },
            ),
            new FlatButton.icon(
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: inputConfirmDialog,
              label: new Text(
                'Save',
                style: new TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.camera_alt),
          tooltip: 'Scan',
          onPressed: () {
            if (controllerDeviceId.text != '') {
              _deviceId = controllerDeviceId.text;
            }
            if (controllerSerialNumber.text != '') {
              _sn = controllerSerialNumber.text;
            }
            if (controllerProductNumber.text != '') {
              _pn = controllerProductNumber.text;
            }

            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (context) => scan.scanning(
                          strSN: _sn,
                          strPN: _pn,
                          strDeviceId: _deviceId,
                          str_selectedModelId: _selectedModelId,
                          str_selectedEntityId: _selectedEntityId,
                          str_selectedTypeId: _selectedTypeId,
                          str_selectedModelName: _selectedModelName,
                          str_selectedEntityName: _selectedEntityName,
                          str_selectedTypeName: _selectedTypeName,
                          str_selectedUserId: _selectedUserId,
                          str_selectedUser: _selectedUser,
                          str_selectedLocation: _selectedLocation,
                          str_selectedLocationId: _selectedLocationId,
                        )));
          },
        ),
        body: new Stack(
          children: <Widget>[
            new ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                  child: TextField(
                    enabled: enableDeviceID,
                    focusNode: fDeviceId,
                    controller: controllerDeviceId,
                    inputFormatters: [MyFormatter.UpperCaseFormatter()],
                    decoration: InputDecoration(
                        labelText: 'Device ID',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10.0, left: 20.0, top: 15.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      iconSize: 20.0,
                      style: TextStyle(fontSize: 17.0, color: Colors.black),
                      value: _selectedTypeId,
                      items: dataType,
                      
                      hint: Text('Select Type'),
                      onChanged: (value) {
                        setState(() {
                          _searchTypeResult = [];

                          _selectedTypeId = value;
                          _selectedModelId = null;
                          //print(_selectedType);
                          //print(_userDetails[int.tryParse(_selectedType)].name);
                          _listDataType.forEach((MapTypeModel) {
                            if (MapTypeModel.id.contains(_selectedTypeId))
                              _searchTypeResult.add(MapTypeModel);
                          });
                          _selectedTypeName = _searchTypeResult[0].name;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10.0, left: 20.0, top: 15.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      iconSize: 20.0,
                      style: TextStyle(fontSize: 17.0, color: Colors.black),
                      value: _selectedModelId,
                      items: dataModel,
                      hint: Text('Select Model'),
                      onChanged: (valuemodel) {
                        //var result = List<dynamic>.
//                        print(_searchResult[1].name);
                        // print(_searchTypeResult[0].name);

                        setState(() {
                          _searchModelResult = [];

                          _selectedModelId = valuemodel;
                          _listDataModel.forEach((MapTypeModel) {
                            if (MapTypeModel.id.contains(_selectedModelId))
                              _searchModelResult.add(MapTypeModel);
                          });
                          _selectedModelName = _searchModelResult[0].name;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                  child: TextField(
                    enabled: enableSN,
                    focusNode: fSerialNumber,
                    controller: controllerSerialNumber,
                    inputFormatters: [MyFormatter.UpperCaseFormatter()],
                    decoration: InputDecoration(
                        labelText: 'Serial Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                  child: TextField(
                    enabled: enablePN,
                    focusNode: fProductNumber,
                    controller: controllerProductNumber,
                    inputFormatters: [MyFormatter.UpperCaseFormatter()],
                    decoration: InputDecoration(
                        labelText: 'Product Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                //entities dropdown
                Container(
                  padding: EdgeInsets.only(right: 10.0, left: 20.0, top: 15.0),
                  child: DropdownButtonHideUnderline(
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
                          _selectedEntityName = _searchEntitiesResult[0].name;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(right: 0.0, left: 5.0, top: 0.0),
                    child: new ListTile(
                      leading: new Text('Location :',
                          style: new TextStyle(fontSize: 16.0)),
                      title: _selectedLocation == null
                          ? new Text('')
                          : new Text(_selectedLocation.toString()),
                      trailing: new IconButton(
                        icon: new Icon(Icons.search),
                        color: Colors.blue,
                        onPressed: () {
                          if (controllerDeviceId.text != '') {
                            _deviceId = controllerDeviceId.text;
                          }
                          if (controllerSerialNumber.text != '') {
                            _sn = controllerSerialNumber.text;
                          }
                          if (controllerProductNumber.text != '') {
                            _pn = controllerProductNumber.text;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationList.HomePage(
                                        strSN: _sn,
                                        strPN: _pn,
                                        strDeviceId: _deviceId,
                                        str_selectedModelId: _selectedModelId,
                                        str_selectedEntityId: _selectedEntityId,
                                        str_selectedTypeId: _selectedTypeId,
                                        str_selectedModelName:
                                            _selectedModelName,
                                        str_selectedEntityName:
                                            _selectedEntityName,
                                        str_selectedTypeName: _selectedTypeName,
                                        str_selectedUserId: _selectedUserId,
                                        str_selectedUser: _selectedUser,
                                        str_selectedLocation: _selectedLocation,
                                      )));
                        },
                      ),
                    )),
                Container(
                    padding: EdgeInsets.only(right: 0.0, left: 5.0, top: 0.0),
                    child: new ListTile(
                      leading: new Text('User :',
                          style: new TextStyle(fontSize: 16.0)),
                      title: _selectedUser == null
                          ? new Text('')
                          : new Text(_selectedUser.toString()),
                      trailing: new IconButton(
                        icon: new Icon(Icons.search),
                        color: Colors.blue,
                        onPressed: () {
                          if (controllerDeviceId.text != '') {
                            _deviceId = controllerDeviceId.text;
                          }
                          if (controllerSerialNumber.text != '') {
                            _sn = controllerSerialNumber.text;
                          }
                          if (controllerProductNumber.text != '') {
                            _pn = controllerProductNumber.text;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UsersList.HomePage(
                                        strSN: _sn,
                                        strPN: _pn,
                                        strDeviceId: _deviceId,
                                        str_selectedModelId: _selectedModelId,
                                        str_selectedEntityId: _selectedEntityId,
                                        str_selectedTypeId: _selectedTypeId,
                                        str_selectedModelName:
                                            _selectedModelName,
                                        str_selectedEntityName:
                                            _selectedEntityName,
                                        str_selectedTypeName: _selectedTypeName,
                                        str_selectedUserId: _selectedUserId,
                                        str_selectedUser: _selectedUser,
                                        str_selectedLocation: _selectedLocation,
                                        str_selectedLocationId:
                                            _selectedLocationId,
                                      )));
                        },
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
  //END OF INTERFACE//

  //METHOD OR FUNCTION ARE HERE//

  Future getcomputerTypes() async {
    try {
      final getTypeResult = await http.get(url + 'getComputerTypes.php');

      final getdataType = json.decode(getTypeResult.body);

      dataType = [];
      //txtselectedType = getdataType;
      for (Map i in getdataType) {
        _listDataType.add(MapIdName.fromJson(i));
      }

      for (var i = 0; i < _listDataType.length; i++) {
        Color color;
        if (i % 2 != 0) {
          color = Colors.amber;
        } else {
          color = Colors.blue[300];
        }
        dataType.add(new DropdownMenuItem(
          child: new Text(
            (_listDataType[i].name),
            style: new TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          value: _listDataType[i].id.toString(),
        ));
      }
      return dataType;
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> getcomputerModels() async {
    try {
      final getModelResult = await http.get(url + 'getComputerModels.php');

      final getdatamodel = json.decode(getModelResult.body);
      //print(getdatamodel.length.toString());
      //for(Map a in )
      for (Map i in getdatamodel) {
        _listDataModel.add(MapIdName.fromJson(i));
      }
      for (var i = 0; i < _listDataModel.length; i++) {
        //txtselectedModel.add(getdatamodel)
        Color color;
        if (i % 2 != 0) {
          color = Colors.amber;
        } else {
          color = Colors.blue[300];
        }
        dataModel.add(new DropdownMenuItem(
          child: new Text(
            (_listDataModel[i].name),
            style: new TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          value: _listDataModel[i].id.toString(),
        ));
      }
      return dataModel;
    } catch (error) {
      print(error);
    }
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

  Future<bool> backButtonDialog() {
    AlertDialog alertBackButton = new AlertDialog(
      title: new Row(
        children: <Widget>[
          Icon(Icons.warning, color: Colors.blue),
          Text(
            'Warning',
            style: new TextStyle(color: Colors.blue),
          )
        ],
      ),
      content:
          new Text('All changes will be discarded, do you want to continue?'),
      actions: <Widget>[
        new RaisedButton(
          color: Colors.green,
          child: new Text(
            'No',
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        new RaisedButton(
          color: Colors.red,
          child: new Text(
            'Yes',
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => menu.mainMenu()));
          },
        )
      ],
    );
    return showDialog(context: context, child: alertBackButton);
  }

  Future<bool> inputConfirmDialog() {
    if (_selectedTypeId != null &&
        _selectedModelId != null &&
        controllerDeviceId.text != "" &&
        controllerProductNumber.text != "" &&
        _selectedLocation != "" &&
        controllerSerialNumber.text != "" &&
        _selectedUser != "" &&
        _selectedEntityId != null) {
      AlertDialog alertInputConfirmation = new AlertDialog(
          title: const Text(
            'Input Confirmation',
          ),
          content: new ListView(
            children: <Widget>[
              new ListTile(
                leading:
                    new Text('ID : ', style: new TextStyle(color: Colors.blue)),
                title: new Text(controllerDeviceId.text,
                    style: new TextStyle(color: Colors.green)),
              ),
              new ListTile(
                leading: new Text('Type : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  //'${txtselectedType[int.tryParse(_selectedType)+1]["name"]}',
                  _selectedTypeName,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text('Model : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  _selectedModelName,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text(
                  'S. Number : ',
                  style: new TextStyle(color: Colors.blue),
                ),
                title: new Text(
                  controllerSerialNumber.text,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text('P. Number : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  controllerProductNumber.text,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text('Entity : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  _selectedEntityName,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text('Location : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  _selectedLocation,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text('User : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  _selectedUser,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new RaisedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: new Text('Cancel'),
                  color: Colors.red[300],
                ),
                trailing: new RaisedButton(
                  onPressed: () {
                    setState(() {
                                          _deviceId = controllerDeviceId.text;
                                          _sn = controllerSerialNumber.text;
                                          _pn = controllerProductNumber.text;
                                        });
                                     inputNewComputer(
                        _deviceId,
                        _selectedEntityId,
                        _selectedTypeId,
                        _selectedModelId,
                        _sn,
                        _pn,
                        _selectedLocationId,
                        _selectedUserId,
                        _selectedUser).then((_result) {
                      new Future.delayed(Duration(milliseconds: 500), () {
                        Navigator.pop(context, true);
                        successInputDialog();
                      });
                    });
                  },
                  child: new Text('Save'),
                  color: Colors.green[400],
                ),
              )
            ],
          ));

      return showDialog(context: context, child: alertInputConfirmation);
    } else {
      AlertDialog alertInputConfirmation = new AlertDialog(
        title: new Row(
          children: <Widget>[
            new Icon(
              Icons.warning,
              color: Colors.red,
            ),
            new Padding(
              padding: EdgeInsets.only(right: 5.0),
            ),
            new Text(
              'STOP',
              style: new TextStyle(color: Colors.red),
            )
          ],
        ),
        content: new Text('Please fill the empty field on the form!'),
        actions: <Widget>[
          new RaisedButton(
            child: new Text(
              'OK',
              style: new TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: () => Navigator.pop(context, true),
          )
        ],
      );

      return showDialog(context: context, child: alertInputConfirmation);
    }
  }

  Future inputNewComputer(
      String computerId,
      String entities_id,
      String computerTypes_id,
      String computerModels_id,
      String sn,
      String pn,
      String locations_id,
      String users_id, 
      String user_name) async {
    String result;
    try {
      final response = await http.post(url + "inputNewComputer.php", body: {
        'id': computerId,
        'entities_id': entities_id,
        'model_id': computerModels_id,
        'type_id': computerTypes_id,
        'sn': sn,
        'pn': pn,
        'user_id': users_id,
        'location_id': locations_id,
        'user_name': _selectedUser, 
        
      });
      result = response.body;
      if (result == "DUPLICATE ID DETECTED") {
        result = "Duplicate ID has been detected";
      } else if (result == "INPUT SUCCESSFULL") {
        result = "Input has been successfull";
      }
      else{
        result = "Error";

      }
      setState(() {
        isSuccessInput = result;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> successInputDialog() {
    AlertDialog successInputInfo = new AlertDialog(
      title: new Text(
        'Information',
        style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      content: new Text(isSuccessInput),
    );
    return showDialog(context: context, child: successInputInfo);
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
