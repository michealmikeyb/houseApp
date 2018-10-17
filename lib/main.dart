import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dialogs.dart';
import 'rulespage.dart';
import 'challengepage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'House App',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.brown,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime now;
  String user;
  BuildContext con;

  void initState(){
    now = new DateTime.now();
    restore();
  }

  void restore() async{
    var prefs =
        await SharedPreferences.getInstance(); //get the shared preferences
    String name = prefs.getString('names') ?? "0";
    if(name == "0"){
      name = await showDialog(
        context: con,
        child: SimpleDialog(
          title: Text("Enter Your Name"),
          children: <Widget>[
            new TextField(
              onSubmitted: (text){
                Navigator.pop(context, text);
              }
            )
          ],
        )
      );
      prefs.setString('name', name);
    }
    user = name;
  }
  

  @override
  Widget build(BuildContext context) {
    con = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Events"),
        
      ),
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(user),
              accountEmail: Text("posting as $user"),
            ),
            new ListTile(
              title: Text("Rules"),
              trailing: Icon(Icons.archive),
              onTap: (){
                Navigator.push(
                  context, 
                  new MaterialPageRoute(
                    builder: (context) => RulesPage())
                  );}
                ),
          new ListTile(
              title: Text("Dog Bowl Challenge"),
              trailing: Icon(Icons.archive),
              onTap: (){
                Navigator.push(
                  context, 
                  new MaterialPageRoute(
                    builder: (context) => ChallengePage())
                  );}
                ),
          ]
        )
      ),
      body: new Center(
        child: new StreamBuilder(
          stream: Firestore.instance.collection("events").where("date", isGreaterThan: now).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData)
              return CircularProgressIndicator();
            var data = snapshot.data.documents;
            return new ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return new ListTile(
                  title: Text(data[index].data["name"]),
                  subtitle: Text("When: ${data[index].data['date']} Where: ${data[index].data['location']}"),
                );
              }
            );
          }
        )
      ),
      floatingActionButton: RaisedButton.icon(
        icon: Icon(Icons.add),
        onPressed: () async{
          await showDialog(
            context: context,
            child: new EventDialog(),
          );
        }
      ),
    );
  }
}
