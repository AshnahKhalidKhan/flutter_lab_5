
import 'dart:convert';
import 'package:flutter_lab_5/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
//ChangeNotifier tells ONLY the widgets that are listening to it, that it has changed

class ProviderClass extends ChangeNotifier //this is our provider class
{
  List<Products>? post;
  bool loading = false;

  getDataFromAPI() async
  {
    loading = true; //we are fetching data
    post = (await fetchingData());
    loading = false; //we have fetched data
    notifyListeners();
  }
}

class MidtermExam extends StatefulWidget
{
  const MidtermExam({super.key});

  @override
  State<MidtermExam> createState() => _MidtermExamState();
}

class _MidtermExamState extends State<MidtermExam>
{
  @override
  void initState() 
  {
    // final postModel = Provider
    Provider.of<ProviderClass>(context, listen: false).getDataFromAPI();
    super.initState();
  }

  Widget build(BuildContext context) 
  {
    final postModel = Provider.of<ProviderClass>(context);
    // return Scaffold
    // (
    //   appBar: AppBar
    //   (
    //     backgroundColor: Colors.white,
    //     title: Text('Products', style: TextStyle(color: Colors.black),),
    //     centerTitle: true,
    //   ),
    //   body: Padding
    //   (
    //     padding: EdgeInsets.all(5.0),
    //     child: futureBuilding(),
    //   )
    // );
    // return postModel.loading ? 
    // Scaffold
    // (
    //   appBar: AppBar
    //   (
    //     backgroundColor: Colors.white,
    //     title: Text('Products', style: TextStyle(color: Colors.black),),
    //     centerTitle: true,
    //   ),
    //   body: Padding
    //   (
    //     padding: EdgeInsets.all(5.0),
    //     child: futureBuilding(),
    //   )
    // )
    // :
    // CircularProgressIndicator();
    while (postModel.loading) 
    {
      return CircularProgressIndicator();
    }
    return Scaffold
    (
      appBar: AppBar
      (
        backgroundColor: Colors.white,
        title: Text('Products', style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: Padding
      (
        padding: EdgeInsets.all(5.0),
        child: futureBuilding(),
      )
    );
  }

  FutureBuilder<List<Products>> futureBuilding() 
  {
    return FutureBuilder
    (
      future: fetchingData(), 
      builder: (context, snapshot)
      {
        if (snapshot.hasData)
        {
          return _buildingView(snapshot.data!);
        }
        if (snapshot.hasData)
        {
          return Text('$snapshot.error');
        }
        else
        {
          return Center
          (
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}


ListView _buildingView(List<Products> itemsList)
{
  return ListView.builder
  (
    itemCount: itemsList.length,
    itemBuilder: (context, i)
    {
      return Card
      (
        color: Colors.white60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: 
          [
            Container
            (
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration
              (
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                image: DecorationImage
                (
                  image: NetworkImage(itemsList[i].thumbnail.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding
            (
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row
              (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: 
                [
                  Text(itemsList[i].title),
                  Row
                  (
                    children: 
                    [
                      Text(itemsList[i].price.toString() + " USD"),
                      IconButton
                      (
                        icon: Icon(Icons.remove_red_eye_sharp),
                        onPressed: () 
                        {
                          showModalBottomSheet<void>
                          (
                            context: context, 
                            isScrollControlled: true,
                            builder: (BuildContext context)
                            {
                              return SizedBox
                              (
                                width: double.infinity,
                                child: Wrap
                                (
                                  children: 
                                  [
                                    Column
                                    (
                                    // 
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: 
                                      [
                                        Container
                                        (
                                          width: double.infinity,
                                          height: 100,
                                          child: ListView
                                          (
                                            scrollDirection: Axis.horizontal,
                                            children: itemsList[i].images != null && itemsList[i].images.isNotEmpty ? itemsList[i].images.map((imageInList) 
                                            {
                                              return Card
                                              (
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                child: Container
                                                (
                                                  decoration: BoxDecoration
                                                  (
                                                    borderRadius: BorderRadius.circular(20.0),
                                                  ),
                                                  child: Image.network
                                                  (
                                                    imageInList,
                                                    
                                                  ),
                                                ),
                                              );
                                            }).toList() : <Widget>[],
                                          ),
                                        ),
                                        ListTile
                                        (
                                          title: Text(itemsList[i].title),
                                          subtitle: Text(itemsList[i].description.toString()),
                                        ),
                                        Padding
                                        (
                                          padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                                          child: Text("\$" + itemsList[i].price.toString()),
                                        ),
                                        Padding
                                        (
                                          padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                                          child: Row
                                          (
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: 
                                            [
                                              Row
                                              (
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: 
                                                [
                                                  Icon(Icons.star),
                                                  Text(itemsList[i].rating.toString()),
                                                ],
                                              ),
                                              Row
                                              (
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: 
                                                [
                                                  Text(itemsList[i].discountPercentage.toString() + "%"),
                                                  Icon(Icons.discount),
                                                ],
                                              ),
                                            ],
                                          ),
                                          
                                        ),
                                      ],
                                    ),
                                  ]
                                ),
                              );
                            }
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding
            (
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Text(itemsList[i].description.toString()),
            ),
          ],
        ),
      );
    },
  );
}



