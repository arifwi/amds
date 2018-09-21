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

  final String url = 'http://172.28.16.84:8089/getMonitorList.php';

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
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
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
            child: _searchComputerResult.length != 0 ||
                    controller.text.isNotEmpty
                ? new ListView.builder(
                    itemCount: _searchComputerResult.length,
                    itemBuilder: (context, i) {
                      return new Card(
                        shape: new Border(
                            bottom: BorderSide(color: Colors.blue, width: 2.0)),
                        child: new ListTile(
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(
                              builder: (context)=> computerDetails.MainComputerDetails(str_selectedTypeName: _searchComputerResult[i].username, 
                              str_selectedEntityName:  _searchComputerResult[i].entities,
                               strSN:_searchComputerResult[i].sn, 
                              str_selectedLocation: _searchComputerResult[i].locations,
                              strPN: _searchComputerResult[i].pn, 
                              str_selectedModelName: _searchComputerResult[i].username,
                              strDeviceId: _searchComputerResult[i].name, 
                              str_selectedUser: _searchComputerResult[i].username,)
                            ));
                          },
                          leading:
                               new Icon(Icons.desktop_windows),
                          title: new Text(_searchComputerResult[i].name),
                          trailing: new Text(_searchComputerResult[i].username,
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        margin: const EdgeInsets.all(0.0),
                      );
                    },
                  )
                : new ListView.builder(
                    itemCount: _computerDetails.length,
                    itemBuilder: (context, index) {
                      
                      return new Card(
                        shape: new Border(
                            bottom: BorderSide(color: Colors.blue, width: 2.0)),
                        child: new ListTile(
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(
                              builder: (context)=> 
                              computerDetails.MainComputerDetails(str_selectedTypeName: _computerDetails[index].username, 
                              str_selectedEntityName:  _computerDetails[index].entities, 
                              strSN:_computerDetails[index].sn, 
                              str_selectedLocation: _computerDetails[index].locations,
                              strPN: _computerDetails[index].pn, 
                              str_selectedModelName: _computerDetails[index].username,
                              strDeviceId: _computerDetails[index].name, 
                              str_selectedUser: _computerDetails[index].username,)
                              
                            ));
                          },
                          leading:
                             new Icon(Icons.desktop_windows),
                          title: new Text(_computerDetails[index].name),
                          trailing: new Text(
                            _computerDetails[index].username,
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        margin: const EdgeInsets.all(0.0),
                      );
                    },
                  ),
          ),
        ],
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
      typeId,
      username,
      firstname,
      lastname,
      entities,
      locations,
      sn,
      pn;

  MapIdNameComputers(
      {this.id,
      this.name,
      this.modelId,
      this.typeId,
      this.firstname,
      this.lastname,
      this.username,
      this.entities,
      this.locations,
      this.pn,
      this.sn});

  factory MapIdNameComputers.fromJson(Map<String, dynamic> json) {
    return new MapIdNameComputers(
        id: json['id'],
        name: json['name'],
        modelId: json['model_id'],
        typeId: json['type_id'],
        username: json['username'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        entities : json['entities_name'],
        locations :json['location_name'],
        sn : json['sn'],
        pn : json['pn']);
  }
}
