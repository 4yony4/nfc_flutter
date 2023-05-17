
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';


class Home2Page extends StatefulWidget {
  const Home2Page({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Home2Page> createState() => _Home2PageState();
}

class _Home2PageState extends State<Home2Page> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  //late TextFormField inputText;
  TextEditingController textController=TextEditingController(text: "Mensaje para guardar en el NFC");
  late StreamSubscription _intentDataStreamSubscription;
  late List<SharedMediaFile> _sharedFiles;
  late String _sharedText;


  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    initIntentData();


  }

  void initIntentData() async {

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //inputText=TextFormField();

    return Scaffold(
      appBar: AppBar(title: Text('NFC Flutter')),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
              ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
              : Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.vertical,
            children: [
              TextFormField(controller: textController,),
              Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(4),
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(border: Border.all()),
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder<dynamic>(
                      valueListenable: result,
                      builder: (context, value, _) =>
                          Text('${value ?? ''}'),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: GridView.count(
                  padding: EdgeInsets.all(4),
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: [
                    ElevatedButton(
                        child: Text('Tag Read'), onPressed: _tagRead),
                    ElevatedButton(
                        child: Text('Ndef Write'),
                        onPressed: _ndefWrite),
                    //ElevatedButton(
                    //    child: Text('Ndef Write Lock'),
                    //    onPressed: _ndefWriteLock),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tagRead() {

  }

  void _ndefWrite() {

  }

}