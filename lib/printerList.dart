import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/Menu.dart' as menu;
import 'package:amds/scanning.dart' as scanning;
import 'package:amds/printerDetails.dart' as printerDetails;

class HomePage extends StatefulWidget {
  
  String str_AppUsername;
  HomePage({this.str_AppUsername});
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _appUsername;

  TextEditingController controller = new TextEditingController();

  List<MapIdNamePrinters> _searchPrinterResult = [];

  List<MapIdNamePrinters> _printerDetails = [];

  String fullname;

  final String url = 
  'http://172.28.16.84:8089/getprinterlist.php';
  //'http://192.168.43.62/amdsweb/getPrinterList.php';

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
    getPrinterDetails().then((value) {
      new Future.delayed(Duration(milliseconds: 1000),
                                  () {
                                
                              });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Printer List'),
        elevation: 0.0,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> scanning.scanning(str_AppUsername: _appUsername,)));
        },
        child: new Icon(Icons.add),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: new Column(
          
          children: <Widget>[
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
              flex: 10,
              child: _searchPrinterResult.length != 0 ||
                      controller.text.isNotEmpty
                  ? new ListView.builder(
                    
                    padding: EdgeInsets.only(right: 10.0,left: 10.0),
                      itemCount: _searchPrinterResult.length,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: new Card(
                            child: new ListTile(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(
                                  builder: (context)=> printerDetails.MainPrinterDetails(
                                  strPN:_searchPrinterResult[i].pn ,
                                  str_selectedTypeId:_searchPrinterResult[i].typeId ,
                                  str_selectedTypeName: _searchPrinterResult[i].typeName, 
                                  str_selectedEntityName:  _searchPrinterResult[i].entities,
                                  str_selectedEntityId: _searchPrinterResult[i].entities_id,
                                  strSN:_searchPrinterResult[i].sn, 
                                  str_selectedLocation: _searchPrinterResult[i].locations,
                                  str_selectedModelId: _searchPrinterResult[i].modelId,
                                  str_selectedModelName: _searchPrinterResult[i].modelName,
                                  strDeviceId: _searchPrinterResult[i].name, 
                                  str_selectedUser: _searchPrinterResult[i].username,
                                  str_selectedUserId: _searchPrinterResult[i].user_id,
                                  str_selectedLocationId: _searchPrinterResult[i].locations_id,)
                                ));
                              },
                              leading:
                                  _searchPrinterResult[i].typeName == 'NOTEBOOK'
                                      ? new Icon(Icons.laptop)
                                      : new Icon(Icons.desktop_mac),
                              title: new Text(_searchPrinterResult[i].name),
                              trailing: new Text(_searchPrinterResult[i].username,
                                  style:
                                      new TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            margin: const EdgeInsets.all(0.0),
                          ),
                        );
                      },
                    )
                  : new ListView.builder(
                    padding: EdgeInsets.only(right: 10.0,left: 10.0, ),
                      itemCount: _printerDetails.length,
                      itemBuilder: (context, index) {
                        
                        
                        return Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: new Card(
                            child: new ListTile(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(
                                  builder: (context)=> 
                                  printerDetails.MainPrinterDetails(
                                  str_selectedTypeName: _printerDetails[index].typeName, 
                                  str_selectedEntityName:  _printerDetails[index].entities, 
                                  str_selectedEntityId: _printerDetails[index].entities_id,
                                  strSN:_printerDetails[index].sn, 
                                  str_selectedLocation: _printerDetails[index].locations,
                                  str_selectedModelName: _printerDetails[index].modelName,
                                  strDeviceId: _printerDetails[index].name, 
                                  str_selectedUser: _printerDetails[index].username,
                                  str_selectedUserId: _printerDetails[index].user_id,
                                  str_selectedLocationId: _printerDetails[index].locations_id,
                                  str_selectedModelId: _printerDetails[index].modelId,
                                  str_selectedTypeId: _printerDetails[index].typeId,
                                  strPN: _printerDetails[index].pn,
                                  )
                                  
                                ));
                              },
                              leading:
                                  _printerDetails[index].typeName == 'NOTEBOOK'
                                      ? new Icon(Icons.laptop)
                                      : new Icon(Icons.desktop_mac),
                              title: new Text(_printerDetails[index].name),
                              trailing: new Text(
                                _printerDetails[index].username,
                                style: new TextStyle(fontWeight: FontWeight.bold),
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

  onSearchTextChanged(String text) async {
    _searchPrinterResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _printerDetails.forEach((userDetail) {
      if (
          userDetail.name.contains(text)||
          userDetail.username.contains(text)||
          userDetail.lastname.contains(text)||
          userDetail.firstname.contains(text))
        _searchPrinterResult.add(userDetail);
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
      pn;

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
      this.sn});

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
        entities : json['entities_name'],
        entities_id : json['entities_id'],
        locations :json['locations_name'],
        locations_id :json['locations_id'],
        sn : json['sn'],
        pn : json['pn']);
  }
}
