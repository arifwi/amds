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
      str_selectedType,
      str_selectedModel,
      str_selectedEntity,
      str_selectedUser,
      str_selectedLocation,
      str_selectedUserId;

  scanning(
      {this.strDeviceId,
      this.strSN,
      this.strPN,
      this.str_selectedType,
      this.str_selectedModel,
      this.str_selectedEntity,
      this.str_selectedLocation,
      this.str_selectedUser,
      this.str_selectedUserId});

  @override
  _scanningState createState() => _scanningState();
}

class _scanningState extends State<scanning> {
  String _selectedType,
      _selectedModel,
      _selectedEntity,
      _selectedUser,
      _selectedUserId;
  String strDeviceId, strPN, strSN;

  bool styleID = false, styleSN = false, stylePN = false;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      if (widget.strDeviceId != null) {
        strDeviceId = widget.strDeviceId;
      } 
      if (widget.strSN != null) {
        strSN = widget.strSN;
      } 
      if (widget.strPN != null) {
        strPN = widget.strPN;
      } 
      if(widget.str_selectedType != null){
        _selectedType = widget.str_selectedType;
        }
      if(widget.str_selectedModel != null){
        _selectedModel = widget.str_selectedModel;
        }
      if(widget.str_selectedEntity != null){
        _selectedEntity= widget.str_selectedEntity;
        }
      
      if(widget.str_selectedUser != null){
        _selectedUser = widget.str_selectedUser;
        }
      if(widget.str_selectedUserId != null){
        _selectedUserId = widget.str_selectedUserId;
        }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (strDeviceId == 'null' && strSN == 'null' && strPN == 'null') {
          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => menu.mainMenu()));
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
            onPressed: backButtonDialog,
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
                  strDeviceId.toString(),
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
                  strSN.toString(),
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
                  strPN.toString(),
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
                    if (strDeviceId == "null" ||
                        strPN == "null" ||
                        strSN == "null") {
                      incompleteDialog();
                    } else {
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => addDevice.mainAdd(
                                  strDeviceId: strDeviceId,
                                  strSN: strSN,
                                  strPN: strPN,
                                  str_selectedType: _selectedType,
                                  str_selectedModel: _selectedModel,
                                  str_selectedEntity: _selectedEntity,
                                  str_selectedUser: _selectedUser,
                                  str_selectedUserId: _selectedUserId)));
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
                        strDeviceId: strDeviceId,
                        strSN: strSN,
                        strPN: strPN,
                        str_selectedType: _selectedType,
                        str_selectedModel: _selectedModel,
                        str_selectedEntity: _selectedEntity,
                        str_selectedUser: _selectedUser,
                        str_selectedUserId: _selectedUserId)));
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
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => menu.mainMenu()));
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
          strDeviceId = barcode;
          styleID = true;
        } else if (whatScan == 'sn') {
          strSN = barcode;
          styleSN = true;
        } else if (whatScan == 'pn') {
          strPN = barcode;
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
