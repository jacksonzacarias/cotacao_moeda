import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=2522a16f";

void main() async {
//print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

// ["results"] ["currencies"]["USD"][""]);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
final realController = TextEditingController();
final dolarController = TextEditingController();
final euroController = TextEditingController();

  double? dolar;
  double? euro;

  void _realChanged(String text){

  }
  void _dolarChanged(String text){
    
  }
  void _euroChanged(String text){
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          //corpo do por que vai retorna um mapa
          future: getData(), // futuro do meu map
          builder: (context, snapshot) {
            // aqui me especifica oque vai mostra na tela
            switch (snapshot.connectionState) {
              // aqui se nao tiver nada ele vai me returna um texto carregando dados
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Carregando dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.00),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro em Carregando Dados...", // caso esteje carregando
                      style: TextStyle(color: Colors.amber, fontSize: 25.00),
                    ),
                  );
                } else {
                  dolar = snapshot.data!["results"] ["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"] ["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150.0, color: Colors.white),
                        Divider(),
                        buildTextField("Reais", "R\$", realController, _realChanged),
                        Divider(),
                        buildTextField("Dólar", "US\$",dolarController,_dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€", euroController, _euroChanged)
                      ],
                    ),
                  );
                  // caso não tenha nada me retorne um widet verde
                }
            }
          }),
    );
  }
}
/*
theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        hintStyle: TextStyle(color: Colors.amber),
      )),
));
*/
Widget buildTextField(String label, String prefix, TextEditingController c, Function(String) f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
