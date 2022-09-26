import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  State<SearchPage> createState() => _HomePageState();
}

class _HomePageState extends State<SearchPage> {
  String secilenSehir;
  final myController = TextEditingController();
   void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("HATA"),
          content: new Text("Geçersiz Bir Şehir Girdiniz"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("KAPAT"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('lib/assets/search.jpg'))),
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.transparent,
        body: Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: myController,
                // onChanged: (value) {
                //   secilenSehir = value;
                //   print(secilenSehir);
                // },
                decoration: InputDecoration(
                    hintText: 'ŞEHİR SEÇİNİZ',
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            FlatButton(
                onPressed: () async {
                  var response = await http.get(
                      'https://www.metaweather.com/api/location/search/?query=${myController.text}');
                  jsonDecode(response.body).isEmpty ? _showDialog():


                  
                  Navigator.pop(
                      context,
                      myController
                          .text); //şehri seç dedikten sonra ilk ekrana dönüyor
                },
                child: Text('şehri seç'))
          ],
        )),
      ),
    );
  }
}
