import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/Menu.dart' as menu;
import 'package:amds/computerDetails.dart' as computerDetails;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = new TextEditingController();

  List<MapIdNameComputers> _searchComputerResult = [];

  List<MapIdNameComputers> _computerDetails = [];

  String fullname;

  final String url = 'http://192.168.43.62/amdsweb/getComputerList.php';

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

    getComputerDetails().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Computer List'),
        elevation: 0.0,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/scanningComputer');
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
              child: _searchComputerResult.length != 0 ||
                      controller.text.isNotEmpty
                  ? new ListView.builder(
                    
                    padding: EdgeInsets.only(right: 10.0,left: 10.0),
                      itemCount: _searchComputerResult.length,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: new Card(
                            child: new ListTile(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(
                                  builder: (context)=> computerDetails.MainComputerDetails(
                                  strPN:_searchComputerResult[i].pn ,
                                  str_selectedTypeId:_searchComputerResult[i].typeId ,
                                  str_selectedTypeName: _searchComputerResult[i].typeName, 
                                  str_selectedEntityName:  _searchComputerResult[i].entities,
                                  str_selectedEntityId: _searchComputerResult[i].entities_id,
                                  strSN:_searchComputerResult[i].sn, 
                                  str_selectedLocation: _searchComputerResult[i].locations,
                                  str_selectedModelId: _searchComputerResult[i].modelId,
                                  str_selectedModelName: _searchComputerResult[i].modelName,
                                  strDeviceId: _searchComputerResult[i].name, 
                                  str_selectedUser: _searchComputerResult[i].username,
                                  str_selectedUserId: _searchComputerResult[i].user_id,
                                  str_selectedLocationId: _searchComputerResult[i].locations_id,)
                                ));
                              },
                              leading:
                                  _searchComputerResult[i].typeName == 'NOTEBOOK'
                                      ? new Icon(Icons.laptop)
                                      : new Icon(Icons.desktop_windows),
                              title: new Text(_searchComputerResult[i].name),
                              trailing: new Text(_searchComputerResult[i].username,
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
                      itemCount: _computerDetails.length,
                      itemBuilder: (context, index) {
                        
                        
                        return Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: new Card(
                            child: new ListTile(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(
                                  builder: (context)=> 
                                  computerDetails.MainComputerDetails(
                                  str_selectedTypeName: _computerDetails[index].typeName, 
                                  str_selectedEntityName:  _computerDetails[index].entities, 
                                  str_selectedEntityId: _computerDetails[index].entities_id,
                                  strSN:_computerDetails[index].sn, 
                                  str_selectedLocation: _computerDetails[index].locations,
                                  str_selectedModelName: _computerDetails[index].modelName,
                                  strDeviceId: _computerDetails[index].name, 
                                  str_selectedUser: _computerDetails[index].username,
                                  str_selectedUserId: _computerDetails[index].user_id,
                                  str_selectedLocationId: _computerDetails[index].locations_id,
                                  str_selectedModelId: _computerDetails[index].modelId,
                                  str_selectedTypeId: _computerDetails[index].typeId,
                                  strPN: _computerDetails[index].pn,
                                  )
                                  
                                ));
                              },
                              leading:
                                  _computerDetails[index].typeName == 'NOTEBOOK'
                                      ? new Icon(Icons.laptop)
                                      : new Icon(Icons.desktop_windows),
                              title: new Text(_computerDetails[index].name),
                              trailing: new Text(
                                _computerDetails[index].username,
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
    _searchComputerResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _computerDetails.forEach((userDetail) {
      if (
          userDetail.name.contains(text)||
          userDetail.username.contains(text)||
          userDetail.lastname.contains(text)||
          userDetail.firstname.contains(text))
        _searchComputerResult.add(userDetail);
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
      pn;

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
      this.sn});

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
        entities : json['entities_name'],
        entities_id : json['entities_id'],
        locations :json['locations_name'],
        locations_id :json['locations_id'],
        sn : json['sn'],
        pn : json['pn']);
  }
}
