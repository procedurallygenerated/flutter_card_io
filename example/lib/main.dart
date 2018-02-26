import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_io/flutter_card_io.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> _data = {};

  @override
  initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _scanCard() async {
    Map<String, dynamic> details;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      details = await FlutterCardIo.scanCard({
        "requireExpiry": true,
        "scanExpiry": true,
        "requireCVV": true,
        "requirePostalCode": true,
        "restrictPostalCodeToNumericOnly": true,
        "requireCardHolderName": true,
        "scanInstructions": "Hola! Fit the card within the box",
      });

    } on PlatformException {
      print("Failed");
      return;
    }

    if (details == null) {
      print("Canceled");
      return;
    }

    if (!mounted) return;

    setState(() {
      _data = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('CardIO sample app'),
        ),
        body: new Column(
          children: <Widget>[
            new Column(
              children: _data.keys.map((String key) {
                return new Text(_data[key].toString());
              }).toList(),
            ),
            new Container(
              margin: new EdgeInsets.all(30.0),
              child: new Center(
                child: new RaisedButton(
                  child: new Text("Scan"),
                  onPressed: _scanCard,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
