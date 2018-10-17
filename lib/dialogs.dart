import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDialog extends StatefulWidget {
  EventDialog({Key key}) : super(key: key);

  _EventDialogState createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  DateTime date;
  String eventName;
  String location;

  void submit() async{
    Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
            Firestore.instance.collection("events").document(),
            {"name": eventName, 
             "location": location,
             "date": date});
      });
  }
  Widget build(BuildContext context) {
    return SimpleDialog(title: Text("Add an Event"),
     children: <Widget>[
      new Row(
        children: <Widget>[
          new Text("Event Name: "),
          new TextField(
            onChanged: (text){
              eventName = text;
            },
          )
        ]
      ),
      new Row(
        children: <Widget>[
          new Text("Event Location: "),
          new TextField(
            onChanged: (text){
              location = text;
            },
          )
        ]
      ),
      new RaisedButton(
        child: Text("Pick a Date"),
        onPressed:()async{
          date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2018),
            lastDate: DateTime(2020),
          );
        }
      ),
      new Row(
        children:<Widget> [
          new FlatButton(
            child: Text("Submit"),
            onPressed: (){
              submit();
              Navigator.pop(context);
            }
          ),
           new FlatButton(
            child: Text("Cancel"),
            onPressed: (){
              Navigator.pop(context);
            }
          )
        ]
      )
    ]);
  }
}
