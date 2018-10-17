import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengePage extends StatelessWidget{
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title:Text("Dog Bowl Challenge Leaderboard")
      ),
      body: new Center(
        child: new StreamBuilder(
          stream: Firestore.instance.collection("dog_bowl").orderBy("time").snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData)
              return CircularProgressIndicator();
            var data = snapshot.data.documents;
            return new ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return new ListTile(
                  title: Text(data[index].data["name"]),
                  subtitle: Text("Time: ${data[index].data['time']} seconds"),
                );
              }
            );
          }
        )
      ),
    );
  }
}