import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:brasil_fields/brasil_fields.dart';

import 'currency_ptbr_input_format.dart';
//import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';

const request = "https://api.hgbrasil.com/finance?format=json&key=2522a16f";

void main() async {
  runApp(
    MaterialApp(
      
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: Colors.white,
        primaryColor: Colors.white,
      ),
    ),
  );
}


Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

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

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  double _convertMaskdouble(String text) {
    final textReplece = text.replaceAll(",", "").replaceAll(".", "");
    final doubleconvet = double.parse(textReplece);
    return doubleconvet / 100;
  }

  String _formatCurrency(double newValue) {
    final formatter = NumberFormat("#,##0.00", "pt_BR");
    String newText = formatter.format(newValue);
    return newText;
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = _convertMaskdouble(text);
    dolarController.text = _formatCurrency(real / dolar!);
    euroController.text = _formatCurrency(real / euro!);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = _convertMaskdouble(text);
    realController.text = _formatCurrency(dolar * this.dolar!);
    euroController.text = _formatCurrency(dolar * this.dolar! / euro!);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = _convertMaskdouble(text);
    realController.text = _formatCurrency(euro * this.euro!);
    dolarController.text = _formatCurrency(euro * this.euro! / dolar!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: Text("Conversor "),
          backgroundColor: Colors.amber.shade300,
          centerTitle: true,
        ),
        body:
         FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Carregando Dados...",
                    style:
                        TextStyle(color: Colors.amber.shade300, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(
                          color: Colors.amber.shade300, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data!["results"]["currencies"]["USD"]["buy"];
                    euro =
                        snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding:
                            EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 40.0),
                            child: 
                             Image.asset("images/ico.png", width: 100,height: 100,),
                            ),

                          //Divider(height: 50,),
                          buildTextField(
                              "Reais", "R\$", realController, _realChanged),
                          Divider(),
                          buildTextField("Dólares", "US\$", dolarController,
                              _dolarChanged),
                          Divider(),
                          buildTextField(
                              "Euros", "€", euroController, _euroChanged),
                        Padding
                        (padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                        child: Text("1º O aplicativo pega a cotação do mercado em tempo real para fazer as conversão.\n 2º As conversão é feita com o valor de compra do dolar!\n 3º App desenvolvido por Jacksonzacarias",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize:  12.0),
                        ),
                        ),
                        
                        
                        
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function(String) f) {
  return TextFormField(
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      CurrencyPtBrInputFormatter(maxDigits: 12),
    ],
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber.shade300),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(50.00),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(50.00),
        ),
        //fillColor: Colors.amber,
        prefixText: prefix),
    style: TextStyle(color: Colors.amber.shade300, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
