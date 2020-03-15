import 'package:advanced_share/advanced_share.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'gif_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String baseApi = "https://api.tenor.com/v1";
  String baseApiKey = "2T3O16IUZDTO";
  String _Search;
  bool _visibleicon = false;
  int _offset = 0;
  FocusNode focusNode = FocusNode();

  final textController_1 = TextEditingController();

  String hintText = 'Pesquisar GIF';

  Future<Map> _getSearch() async {
    http.Response reponse;

    if (_Search == null || _Search.isEmpty)

      reponse = await http
          .get("$baseApi/trending?key=$baseApiKey&limit=20&contentfilter=medium");
    else
      reponse = await http.get(
          "$baseApi/search?key=$baseApiKey&q=$_Search&pos=$_offset&limit=19&&contentfilter=medium");
    return json.decode(reponse.body);
  }

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          hintText = '';

          _visibleicon = true;
        } else {
          hintText = 'Pesquisar GIF';
          _visibleicon = false;
        }
      });
    });
  }

  Color gradientStart = Colors.grey[800];
  Color gradientEnd = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset("assets/logo.jpg"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [gradientStart, gradientEnd],
                begin: const FractionalOffset(0.5, 0.0),
                end: const FractionalOffset(0.0, 0.5),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextField(
                  focusNode: focusNode,
                  controller: textController_1,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    filled: true,
                    contentPadding: EdgeInsets.only(bottom: 25.0, left: 25.0),
                    fillColor: Colors.white,
                    hintText: hintText,
                    hintStyle: TextStyle(fontSize: 18.0, color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 3.0)),
                    prefixIcon: IconButton(
                        icon: Icon(Icons.search, color: Colors.black),
                        onPressed: () {}),
                    suffixIcon: Visibility(
                      child: IconButton(
                          icon: Icon(Icons.clear, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              textController_1.text = "";
                              _Search = "";
                              _offset = 0;
                              _visibleicon = false;
                            });
                          }),
                      visible: _visibleicon,
                    ),
                  ),
                  style:
                      TextStyle(color: Colors.deepPurpleAccent, fontSize: 18.0),
                  onSubmitted: (text) {
                    setState(() {
                      _Search = textController_1.text;
                      _Search = text;
                      _offset = 0;
                      _visibleicon = true;
                    });
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: _getSearch(),
                    builder: (context, snaphot) {
                      switch (snaphot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return new Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 5.0,
                            ),
                          );
                        default:
                          print(snaphot.data["results"].length);
                          if (snaphot.hasError)
                            return new Text('Error: ${snaphot.error}');
                        else if(snaphot.data["results"].length < 1)
                          return Container(child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  },
                                child: Text(
                                  "Não tem nenhum Resultado",
                                  style: TextStyle(color: Colors.white,fontSize: 20.0),
                                ),
                                color: Colors.deepPurpleAccent,
                              )
                            ],
                          )
                            );
                          else
                            return _createGifTable(context, snaphot);
                      }
                    }),
              ),
            ],
          ),
        ));
  }

  int _getCount(List data) {
    if (_Search == null || _Search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0),
        itemCount: _getCount(snapshot.data["results"]),
        itemBuilder: (context, index) {

          if (_Search == null || _Search.isEmpty || index < snapshot.data["results"].length)
            return GestureDetector(
              child: Container(
                  padding: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(2.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/loading.gif',
                      image: snapshot.data["results"][index]["media"][0]["tinygif"]
                      ["url"],
                      height: 300.0,
                      fit: BoxFit.cover,
                    )),
              )




              ,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data["results"][index])));
              },
              onLongPress: () async {
             final   http.Response _imagem = await http.get(
                  snapshot.data["results"][index]["media"][0]["tinygif"]["url"],
                );
                AdvancedShare.generic(
                  url: "data:image/gif;base64,${base64Encode(_imagem.bodyBytes)}",
                ).then((response){
                  print(response);
                });
              },
            );
          else if(snapshot.data["results"].length >=  19 )
            return Container(
                child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _offset += 19;
                      });
                    },
                    child: Text(
                      "VER MAIS GIFS",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.deepPurpleAccent,
                  )
                ],
              ),
            ));

        });
  }
}
