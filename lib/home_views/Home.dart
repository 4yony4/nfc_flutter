
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void initIntentData() async{
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    print("DEBUG!!!! --->>>>>> "+ReceiveSharingIntent.getInitialText().toString());
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
          setState(() {
            _sharedText = value;
            print("DEBUG --->>>>>> "+_sharedText);
          });
        }, onError: (err) {
          print("DEBUG --->>>>>> getLinkStream error: $err");
        });

    //Stream<String> stream=await ReceiveSharingIntent.getTextStream();
    //String res= await stream.first;
    //print("DEBUG --->>>>>> "+res);
    //Stream<String> stream=await ReceiveSharingIntent.getTextStream();
    //print("DEBUG --->>>>>> "+stream.toString());
    ReceiveSharingIntent.getInitialTextAsUri().then((value) {
      if(value != null){
        setState(() {
          _sharedText = value.toString();
          print("DEBUG --->>>>>> 22222"+_sharedText);
        });
      }
      else{
        print("DEBUG --->>>>>> 22222 NULL");
      }

    });
    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((value) {
      if(value != null){
        setState(() {
          _sharedText = value;
          print("DEBUG --->>>>>> "+_sharedText);
        });
      }
      else{
        print("DEBUG --->>>>>> NULL");
      }

    });
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
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {

      //result.value = tag.data;
      Map tagData = tag.data;
      Map tagNdef = tagData['ndef'];
      Map cachedMessage = tagNdef['cachedMessage'];
      Map records = cachedMessage['records'][0];
      Uint8List payload = records['payload'];
      String payloadAsString = String.fromCharCodes(payload);
      result.value = payloadAsString;
// or with the dart:convert library String payloadAsString = utf8.decode(payload)
      NfcManager.instance.stopSession();
    });
  }

  void _ndefWrite() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      NdefMessage message = NdefMessage([
        //NdefRecord.createText('Hello World!'),

        //NdefRecord.createUri(Uri.parse('https://eurekamps.com')),
        //NdefRecord.createUri(Uri.parse('example://gizmos')),
        //NdefRecord.createExternal("com.example", "externalType", Uint8List.fromList('HEY!'.codeUnits)),
      NdefRecord.createMime('application/vnd.com.example.android.beam', Uint8List.fromList('hfhsnd23yuisbd24aas2'.codeUnits)),
        //NdefRecord.createText("hfhsnd23yuisbd24aas2")
        //NdefRecord.createMime(
        //    'text/plain', Uint8List.fromList('Hello'.codeUnits)),
        //NdefRecord.createExternal('android.com', 'pkg', Uint8List.fromList('com.example.nfc_flutter'.codeUnits)),
        //NdefRecord.createExternal('ios.com', 'pkg', Uint8List.fromList('com.example.nfc_flutter'.codeUnits)),
        //NdefRecord.createMime("Content-type", Uint8List.fromList('vnd.com.example.nfc_flutter'.codeUnits))
        //NdefRecord.type("Content-type", "vnd.app.reliqium.reliqium")
      ]);

      try {
        await ndef.write(message);
        result.value = 'Success to "Ndef Write"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  void _ndefWriteLock() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null) {
        result.value = 'Tag is not ndef';
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }

      try {
        await ndef.writeLock();
        result.value = 'Success to "Ndef Write Lock"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }
}