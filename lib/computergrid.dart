import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/addDevice.dart' as addDevice;
import  'package:amds/Menu.dart' as menu;

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  TextEditingController controller = new TextEditingController();

  List<MapIdName> _searchResult = [];

  List<MapIdName> _computerDetails = [];

  String fullname;

  //final String url = 'http://192.168.43.62/amdsweb/getUsers.php';
  final String url = 'http://172.28.16.84:8089/getComputerList.php';

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _computerDetails.add(MapIdName.fromJson(user));
      }
    });
  }

  @override
  void initState() {
    
    super.initState();
    
    getUserDetails().then((value){
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Computer List'),
          elevation: 0.0,
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: (){
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
              child: _searchResult.length != 0 || controller.text.isNotEmpty
                  ? new GridView.builder(
                      itemCount: _searchResult.length,
                      itemBuilder: (context, i) {
                        return new Card(
                          child: new ExpansionTile(
                            leading: new Icon(
                              Icons.person_pin,
                              size: 40.0,
                              color: Colors.blue,
                            ),
                            title: new Text(
                              _searchResult[i].name,
                            ),
                            children: <Widget>[
                              new ListTile(
                                title: new Text(
                                  '${_searchResult[i].modelName} ${_searchResult[i].typeName}',
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: new FlatButton(
                                  child: new Text(
                                    'Select',
                                    style: new TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.all(0.0),
                        );
                      },
                    )
                  : new GridView.builder(
                    itemCount: _computerDetails.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:  3),
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: new GridTile(
                footer: new Text(_computerDetails[index].name),
                  child: new Text(_computerDetails[index].modelName), //just for testing, will fill with image later
              ),
            );
          },
                  )
            ),
          ],
        ),
      
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _computerDetails.forEach((userDetail) {
      if (userDetail.id.contains(text) ||
          userDetail.name.contains(text) ||
          userDetail.modelName.contains(text) ||
          userDetail.typeName.contains(text)) _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

class MapIdName {
  //used by get selected type and selected model
  final String id, name, modelId, modelName, typeId, typeName;

  MapIdName({this.id, this.name, this.modelId, this.modelName, this.typeId, this.typeName});

  factory MapIdName.fromJson(Map<String, dynamic> json) {
    return new MapIdName(
      id: json['id'],
      name: json['name'],
      modelId: json['model_id'],
      modelName: json['model_name'],
      typeId: json['type_id'],
      typeName : json['type_name'],
    );
  }
}
