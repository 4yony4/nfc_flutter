
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




class Product extends StatefulWidget{
  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {

  late String showingKey="NO KEY!";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productKey=prefs.getString('nfcMessage');
    //print("-------------------->>>>>>>>>>>>>>>>>>>>>   "+productKey!);
    setState(() {
      showingKey=productKey!;
    });
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(title: Text('PRODUCT')),
        body:Text(showingKey)
    );


  }
}