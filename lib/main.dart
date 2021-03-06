import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:amds/Menu.dart' as menu;
import 'package:amds/addDevice.dart' ;
import 'package:amds/scanning.dart' as scanningComputer;
import 'package:amds/usersList.dart' as userList;
import 'package:amds/locationsList.dart'as locationList;
import 'package:amds/computerList.dart' as commputerList;
import 'package:amds/movementDevices.dart' as movementDevices;
import 'package:amds/utils/myClass.dart' as utils;



void main() {
SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
   runApp(new MyApp());

});
}
String username = '', users_id = '',firstname ='', lastname= '';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MGLPI(Asset)',
      theme: new ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.amber
      ),
      home: new LoginPage(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/mainMenu': (BuildContext context) => new menu.mainMenu(),
        '/addComputer': (BuildContext context)=> new mainAdd(),
        '/scanningComputer' : (BuildContext context)=> new scanningComputer.MainScanning(),
        '/userList' : (BuildContext context)=> new userList.HomePage(),
        '/locationList' : (BuildContext context) => locationList.HomePage(),
        '/computerList' : (BuildContext context) => commputerList.HomePage(),
        '/movementDevices': (BuildContext context)=> movementDevices.MainMovementDevices(),



      },
    );
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txt_username = new TextEditingController();
  TextEditingController txt_password = new TextEditingController();
  String message = '';
  String url = utils.defaultUrl;
  Future<dynamic> _checkLogin() async {
    setState(() {
      message = '';
    });
    try {
      final response = await http.post(url + "login.php", body: {
        
        'username': txt_username.text,
        'password': txt_password.text,
      });
      if (response.statusCode == 200) {
        var datauser = json.decode(response.body);
        if (datauser.length == 0) {
          setState(() {
            message = 'Login Failed, incorrect username or password!';
          });
        } else {

          //print(datauser[0]["username"]);
          setState(() {
            username = datauser[0]["lastname"] + " "+datauser[0]["firstname"]+" "+"("+datauser[0]["users_id"]+")";
           
            //print(username);
          });
          Navigator.pushReplacement(context, MaterialPageRoute( builder: (context)=> menu.mainMenu(str_AppUsername: username,)));

        }
      }
      else{
        message = 'Connection failed ${response.statusCode}';
      }
    } catch (e) {
      print(e);
      message = e.toString();
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: ListView(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            children: <Widget>[
              new Column(
                children: <Widget>[
                  
                   new Padding(
                    padding: EdgeInsets.only(top: 50.0),
                  ),
                  new Text('Mobile GLPI',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.0)),
                  new Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  new TextField(
                    controller: txt_username,
                    decoration: InputDecoration(hintText: 'Username'),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  new TextField(
                    controller: txt_password,
                    decoration: InputDecoration(hintText: 'Password'),
                    obscureText: true,
                  ),
                ],
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              new RaisedButton(
                color: Theme.of(context).accentColor,
                child: new Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () {
                  _checkLogin();
                },
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              new Text(
                message,
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }
}
