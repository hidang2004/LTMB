  import 'package:flutter/material.dart';

  class MyScaffold extends StatelessWidget{
    const MyScaffold({super.key});

    @override
    Widget build(BuildContext context) {
      // Tra ve Scaffold - widget cung cap bo cuc Material Design co ban
      // Man hinh
      return Scaffold(
        // Tieu de cua ung dung
          appBar: AppBar(
            title: Text("App 02"),
          ),
        backgroundColor: Colors.green,

        body: Center(child: Text("Noi dung chinh"),),

        floatingActionButton: FloatingActionButton(
            onPressed: (){print("pressed");},
            child:  const Icon(Icons.add_ic_call),
        ),
            bottomNavigationBar: BottomNavigationBar(items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang Chu"),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tim Kiem"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Ca Nhan"),
            ]),
      );
    }
  }