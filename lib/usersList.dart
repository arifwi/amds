import 'dart:async';
import 'dart:convert';

import 'package:amds/utils/formatter.dart' as MyFormatter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_permissions/simple_permissions.dart';

class HomePage extends StatefulWidget {
  String strDeviceId,
      strPN,
      strSN,
      str_selectedType,
      str_selectedModel,
      str_selectedEntity,
      str_selectedUser,
      str_selectedLocation,
      str_selectedUserId;
  HomePage(
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
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = new TextEditingController();

  List<MapIdName> _searchResult = [];

  List<MapIdName> _userDetails = [];

  String fullname;

  final String url = 'http://192.168.43.62/amdsweb/getUsers.php';

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(MapIdName.fromJson(user));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Select User'),
        elevation: 0.0,
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
                  ? new ListView.builder(
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
                          
                                title:new Text('${_searchResult[i].firstname} ${_searchResult[i].lastname}', style: new TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold
                                  
                                ),),
                                trailing: new FlatButton(
                                  child: new Text('Select', style: new TextStyle(color: Colors.white),),
                                  color: Colors.blue,
                                  onPressed: (){},
                                ),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.all(0.0),
                        );
                      },
                    )
                  : new ListView.builder(
                      itemCount: _userDetails.length,
                      itemBuilder: (context, index) {
                        return new Card(
                          child: new ExpansionTile(
                            leading: new Icon(
                              Icons.person_pin,
                              size: 40.0,
                              color: Colors.blue,
                            ),
                            title: new Text(_userDetails[index].name),
                            children: <Widget>[
                              new ListTile(
                          
                                title:new Text('${_userDetails[index].firstname} ${_userDetails[index].lastname}', style: new TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold
                                  
                                ),),
                                trailing: new FlatButton(
                                  child: new Text('Select', style: new TextStyle(color: Colors.white),),
                                  color: Colors.blue,
                                  onPressed: (){},
                                ),
                              ),
                            ],
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
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
     if (userDetail.id.contains(text) || userDetail.name.contains(text) || userDetail.firstname.contains(text)|| userDetail.lastname.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

class MapIdName {
  //used by get selected type and selected model
  final String id, name, firstname, lastname;

  MapIdName({this.id, this.name, this.firstname, this.lastname});

  factory MapIdName.fromJson(Map<String, dynamic> json) {
    return new MapIdName(
      id: json['id'],
      name: json['name'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}
