
import 'dart:convert';
import 'package:flutter_lab_5/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DataClass extends ChangeNotifier
{
  List<Products>? post;
  bool loading = false;

  getData() async
  {
    loading = true;
    post = (await _fetchingData());
    loading = false;
    notifyListeners();
  }
}

Future<List<Products>> _fetchingData() async
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

