import 'dart:async';

import 'package:flutter/material.dart';
import 'package:amds/addDevice.dart' as addDevice;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:amds/Menu.dart' as menu;

class scanning extends StatefulWidget {
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

  scanning({
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
  _scanningState createState() => _scanningState();
}

class _scanningState extends State<scanning> {
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

  bool styleID = false, styleSN = false, stylePN = false;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
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
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_deviceId == null && _sn == null && _pn == null) {
          Navigator.pushReplacementNamed(context, '/computerList');
        } else {
          backButtonDialog();
        }
      },
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('Scan The Barcode'),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              if (_deviceId == null && _sn == null && _pn == null) {
                Navigator.pushReplacementNamed(context, '/computerList');
              } else {
                backButtonDialog();
              }
            },
          ),
        ),
        body: new Center(
            child: ListView(
          children: <Widget>[
            ListTile(
                leading: Text(
                  'Device ID :',
                  style: new TextStyle(fontSize: 15.0),
                ),
                title: Text(
                  _deviceId.toString(),
                  style: styleID
                      ? TextStyle(color: Colors.green)
                      : TextStyle(color: Colors.red),
                ),
                trailing: new RaisedButton.icon(
                  icon: new Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Scan',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    scan('id');
                  },
                  color: Colors.blue,
                )),
            ListTile(
                leading: Text(
                  'Serial Number :',
                  style: new TextStyle(fontSize: 15.0),
                ),
                title: Text(
                  _sn.toString(),
                  style: styleSN
                      ? TextStyle(color: Colors.green)
                      : TextStyle(color: Colors.red),
                ),
                trailing: new RaisedButton.icon(
                  icon: new Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Scan',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    scan('sn');
                  },
                  color: Colors.blue,
                )),
            ListTile(
                leading: Text(
                  'Product Number :',
                  style: new TextStyle(fontSize: 15.0),
                ),
                title: Text(
                  _pn.toString(),
                  style: stylePN
                      ? TextStyle(color: Colors.green)
                      : TextStyle(color: Colors.red),
                ),
                trailing: new RaisedButton.icon(
                  icon: new Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Scan',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    scan('pn');
                  },
                  color: Colors.blue,
                )),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            ListTile(
                leading: new RaisedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => menu.mainMenu()));
                  },
                  icon: new Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  label: new Text(
                    'Cancel',
                    style: new TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                ),
                trailing: new RaisedButton.icon(
                  label: new Text(
                    'Next',
                    style: new TextStyle(color: Colors.white),
                  ),
                  icon: new Icon(Icons.navigate_next, color: Colors.white),
                  onPressed: () {
                    if (_deviceId == null || _pn == null || _sn == null) {
                      incompleteDialog();
                    } else {
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => addDevice.mainAdd(
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
                    }
                  },
                  color: Colors.green,
                ))
          ],
        )),
      ),
    );
  }

  void incompleteDialog() {
    AlertDialog alertScanDeviceid = new AlertDialog(
      title: new Row(
        children: <Widget>[Icon(Icons.warning), Text('Warning')],
      ),
      content: new Text(
          'The required value is still null, you have to input manual on the next page. Do you want to continue? '),
      actions: <Widget>[
        new RaisedButton(
          color: Colors.green,
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text(
            'No',
            style: new TextStyle(color: Colors.white),
          ),
        ),
        new RaisedButton(
          color: Colors.red,
          onPressed: () {
            Navigator.pop(context);

            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (context) => addDevice.mainAdd(
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
                        str_selectedLocationId: _selectedLocationId)));
          },
          child: new Text(
            'Yes',
            style: new TextStyle(color: Colors.white),
          ),
        )
      ],
    );
    showDialog(context: context, child: alertScanDeviceid);
  }

  Future<bool> backButtonDialog() {
    AlertDialog alertScanDeviceid = new AlertDialog(
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
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/computerList');
          },
        )
      ],
    );
    return showDialog(context: context, child: alertScanDeviceid);
  }

  Future<Null> scan(String whatScan) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        if (whatScan == 'id') {
          _deviceId = barcode;
          styleID = true;
        } else if (whatScan == 'sn') {
          _sn = barcode;
          styleSN = true;
        } else if (whatScan == 'pn') {
          _pn = barcode;
          stylePN = true;
        }
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          print('The user did not grant the camera permission!');
        });
      } else {
        setState(() => print('Unknown error: $e'));
      }
    } on FormatException {
      setState(() => print(
          'null (User returned using the "back"-button before scanning anything. Result)'));
    } catch (e) {
      setState(() => print('Unknown error: $e'));
    }
  }
}
