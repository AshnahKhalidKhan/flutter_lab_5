import 'package:flutter/material.dart';
import 'package:flutter_lab_5/DataClass.dart';
import 'package:provider/provider.dart';

void main() {
  runApp
  (

    const MainApp()
  );
}

class MainApp extends StatelessWidget 
{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    // return const MaterialApp
    // (
    //   home: Scaffold
    //   (
    //     body: Center
    //     (
    //       child: Text('Hello World!'),
    //     ),
    //   ),
    // );
    return ChangeNotifierProvider
    (
      create: (context) => DataClass(),
      child: MaterialApp
      (
        title: 'Provider Class',
        theme: ThemeData
        (
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
          useMaterial3: true,
        ),
        home: const MidtermExam(),
      ),
    );
  }
}
