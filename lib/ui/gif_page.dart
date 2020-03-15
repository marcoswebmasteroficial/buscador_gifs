import 'package:flutter/material.dart';
import 'package:advanced_share/advanced_share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gif"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share),color: Colors.white,
              onPressed:() async {
                final http.Response _imagem = await http.get(
                  _gifData["media"][0]["tinygif"]["url"],
                );

                AdvancedShare.generic(
                    url: "data:image/gif;base64,${base64Encode(_imagem.bodyBytes)}",
                ).then((response){
                  print(response);
                });
              })
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
          child:Container(
            padding: const EdgeInsets.all(1.0),
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0)
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/loading.gif',
                  image: _gifData["media"][0]["tinygif"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover,
                )),
          )




             ),
    );
  }
}
