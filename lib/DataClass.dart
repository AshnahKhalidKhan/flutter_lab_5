
import 'dart:convert';
import 'package:flutter_lab_5/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<List<Products>> fetchingData() async
{
  final respnse = await http.get(Uri.parse('https://dummyjson.com/products'));
  if (respnse.statusCode == 200)
  {
    List<dynamic> _parsedList = jsonDecode(respnse.body)['products'];
    List<Products> _itemsList = List<Products>.from
    (
      _parsedList.map<Products>((dynamic i) => Products.fromJson(i))
    );
    return _itemsList;
  }
  else
  {
    throw Exception('Erorrr');
  }
}

//API calling is business logic, not frontend logic
//setState is only available in stateful widget
//For changing state in class, you will use ChangeNotifier

class DataClass extends ChangeNotifier //this is our provider class
{
  List<Products>? post;
  bool loading = false;

  getData() async
  {
    loading = true; //we are fetching data
    post = (await fetchingData());
    loading = false; //we have fetched data
    notifyListeners();
  }
}


