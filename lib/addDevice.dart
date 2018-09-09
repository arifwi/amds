import 'dart:async';
import 'dart:convert';

import 'package:amds/Menu.dart' as menu;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_permissions/simple_permissions.dart';
import 'package:amds/before_adddevice.dart' as scan;
import 'package:amds/usersList.dart' as UsersList;

class mainAdd extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  String strDeviceId,
      strPN,
      strSN,
      str_selectedType,
      str_selectedModel,
      str_selectedEntity,
      str_selectedUser,
      str_selectedLocation,
      str_selectedUserId;
  mainAdd(
      {this.onPressed,
      this.tooltip,
      this.icon,
      this.strDeviceId,
      this.strSN,
      this.strPN,
      this.str_selectedType,
      this.str_selectedModel,
      this.str_selectedEntity,
      this.str_selectedLocation,
      this.str_selectedUser,
      this.str_selectedUserId});

  @override
  mainAddState createState() {
    return new mainAddState();
  }
}

class mainAddState extends State<mainAdd> with SingleTickerProviderStateMixin {
  String url = 'http://192.168.43.62/amdsweb/';
  //String url = 'http://172.28.16.84:8089/';

  Permission permission = Permission.Camera;

  TextEditingController controllerDeviceId = new TextEditingController();
  TextEditingController controllerSerialNumber = new TextEditingController();
  TextEditingController controllerProductNumber = new TextEditingController();
  TextEditingController controllerLocation = new TextEditingController();
  TextEditingController controllerUser = new TextEditingController();

  FocusNode fDeviceId = new FocusNode();
  FocusNode fSerialNumber = new FocusNode();
  FocusNode fProductNumber = new FocusNode();
  FocusNode fLocation = new FocusNode();
  FocusNode fUser = new FocusNode();

  bool enableDeviceID, enableSN, enablePN;

  String _selectedType,
      _selectedModel,
      _selectedEntity,
      _selectedUser,
      _selectedUserId;

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

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  bool _isUnlock = true;
  Icon iconLock = new Icon(Icons.lock);
  Icon iconLockOpen = new Icon(Icons.lock_open);
  String aaa;

  @override
  void initState() {
    // TODO: implement initState
    String wDevId = widget.strDeviceId,
        wPN = widget.strPN,
        wSN = widget.strSN,
        wSelectedType = widget.str_selectedType,
        wSelectedModel = widget.str_selectedModel,
        wSelectedEntity = widget.str_selectedEntity,
        wSelectedUser = widget.str_selectedUser,
        wSelectedLoc = widget.str_selectedLocation,
        wSelectedUserId = widget.str_selectedUserId;

    aaa = widget.strDeviceId;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();

    getcomputerTypes().then((result) {
      new Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _result = result;
          getcomputerModels().then((result) {
            getEntities().then((result) {
              setState(() {
                if (wDevId != null) {
                  controllerDeviceId.text = wDevId;
                  _isUnlock = false;
                }
                if (wPN != null) {
                  controllerProductNumber.text = wPN;
                  _isUnlock = false;
                }
                if (wSN != null) {
                  controllerSerialNumber.text = wSN;
                  _isUnlock = false;

                }
                if (wSelectedType != null) {
                  _selectedType = wSelectedType;
                }
                if (wSelectedModel != null) {
                  _selectedModel = wSelectedModel;
                }
                if (wSelectedEntity != null) {
                  _selectedEntity = wSelectedEntity;
                }
                if (wSelectedUser != null) {
                  _selectedUser = wSelectedUser;
                }
                if (wSelectedLoc != null) {}
                if (wSelectedUserId != null) {
                  _selectedUserId = wSelectedUserId;
                }
              });
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
                _isUnlock == true ? _isUnlock= false: _isUnlock= true;
                
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
        floatingActionButton: new Row(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
            ),
            new FloatingActionButton(
              child: iconLock,
              onPressed: () {
                enableDeviceID = true;
              },
            ),
          ],
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
                    decoration: InputDecoration(
                        labelText: 'ID Device',
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
                      value: _selectedType,
                      items: dataType,
                      hint: Text('Select Type'),
                      onChanged: (value) {
                        setState(() {
                          _searchTypeResult = [];

                          _selectedType = value;
                          _selectedModel = null;
                          //print(_selectedType);
                          //print(_userDetails[int.tryParse(_selectedType)].name);
                          _listDataType.forEach((MapTypeModel) {
                            if (MapTypeModel.id.contains(_selectedType))
                              _searchTypeResult.add(MapTypeModel);
                          });
                          //print(_searchResult);
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
                      value: _selectedModel,
                      items: dataModel,
                      hint: Text('Select Model'),
                      onChanged: (valuemodel) {
                        _searchModelResult = [];
                        //var result = List<dynamic>.
//                        print(_searchResult[1].name);
                        // print(_searchTypeResult[0].name);

                        setState(() {
                          _selectedModel = valuemodel;
                          _listDataModel.forEach((MapTypeModel) {
                            if (MapTypeModel.id.contains(_selectedModel))
                              _searchModelResult.add(MapTypeModel);
                          });
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
                      value: _selectedEntity,
                      items: dataEntities,
                      hint: Text('Select Entitiy'),
                      onChanged: (value) {
                        setState(() {
                          _selectedEntity = value;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                    child: new ListTile(
                      leading: new Text('User :'),
                      title: new Text(_selectedUser.toString()),
                      trailing: new FlatButton.icon(
                        icon: new Icon(Icons.search),
                        label: new Text('Search'),
                        color: Colors.amber,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UsersList.HomePage(
                                        strSN: controllerSerialNumber.text,
                                        strPN: controllerProductNumber.text,
                                        strDeviceId: controllerDeviceId.text,
                                        str_selectedModel: _selectedModel,
                                        str_selectedEntity: _selectedEntity,
                                        str_selectedType: _selectedType,
                                        str_selectedUserId: _selectedUserId,
                                      )));
                        },
                      ),
                    )),
                Container(
                    padding:
                        EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                    child: new ListTile(
                      leading: new Text('User :'),
                      title: new Text(_selectedUser.toString()),
                      trailing: new FlatButton.icon(
                        icon: new Icon(Icons.search),
                        label: new Text('Search'),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UsersList.HomePage(
                                        strSN: controllerSerialNumber.text,
                                        strPN: controllerProductNumber.text,
                                        strDeviceId: controllerDeviceId.text,
                                        str_selectedModel: _selectedModel,
                                        str_selectedEntity: _selectedEntity,
                                        str_selectedType: _selectedType,
                                        str_selectedUserId: _selectedUserId,
                                      )));
                        },
                      ),
                    )),
              ],
            ),
            Positioned(
                bottom: 16.0,
                right: 16.0,
                child: Column(
                  children: <Widget>[
                    Transform(
                      transform: Matrix4.translationValues(
                        0.0,
                        _translateButton.value * 2.0,
                        0.0,
                      ),
                      child: wlockUnlock(),
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                        0.0,
                        _translateButton.value,
                        0.0,
                      ),
                      child: wScan(),
                    ),
                    toggle(),
                  ],
                ))
          ],
        ),
      ),
    );
  }
  //END OF INTERFACE//

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  Widget wlockUnlock() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        tooltip: 'Save the new device',
        child: _isUnlock == true ? iconLockOpen : iconLock,
      ),
    );
  }

  Widget wScan() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          String id, sn, pn;
          if (controllerDeviceId.text != '') {
            id = controllerDeviceId.text;
          }
          if (controllerSerialNumber.text != '') {
            sn = controllerSerialNumber.text;
          }
          if (controllerProductNumber.text != '') {
            pn = controllerProductNumber.text;
          }

          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => scan.scanning(
                      strDeviceId: id,
                      strSN: sn,
                      strPN: pn,
                      str_selectedType: _selectedType,
                      str_selectedModel: _selectedModel,
                      str_selectedEntity: _selectedEntity,
                      str_selectedUser: _selectedUser,
                      str_selectedUserId: _selectedUserId)));
        },
        tooltip: 'Back to scanning page',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
  //METHOD OR FUNCTION ARE HERE//

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

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
            Navigator.pop(context, true);
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => menu.mainMenu()));
          },
        )
      ],
    );
    return showDialog(context: context, child: alertBackButton);
  }

  Future<bool> inputConfirmDialog() {
    if (_selectedType != null &&
        _selectedModel != null &&
        controllerDeviceId.text != "" &&
        controllerProductNumber.text != "" &&
        controllerLocation.text != "" &&
        controllerSerialNumber.text != "" &&
        controllerUser.text != "") {
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
                  _searchTypeResult[0].name,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text('Model : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  _searchModelResult[0].name,
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
                leading: new Text('Location : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  controllerLocation.text,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text('User : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  controllerLocation.text,
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
                    inputNewComputer(
                        controllerDeviceId.text,
                        _selectedType,
                        _selectedModel,
                        controllerSerialNumber.text,
                        controllerProductNumber.text,
                        controllerLocation.text,
                        controllerUser.text).then((_result) {
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
      String computerTypes_id,
      String computerModels_id,
      String sn,
      String pn,
      String locations_id,
      String users_id) async {
    String result;
    try {
      final response = await http.post(url + "inputNewComputer.php", body: {
        'id': computerId,
        'model_id': computerModels_id,
        'type_id': computerTypes_id,
        'sn': sn,
        'pn': pn,
        'user_id': users_id,
        'location_id': locations_id,
      });
      if (response.body == "DUPLICATE ID DETECTED") {
        result = "Duplicate ID has been detected";
      } else {
        result = "Input has been successfull";
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
