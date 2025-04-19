import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Tra ve Scaffold - widget cung cap bo cuc Material Design co ban
    // Man hinh
    return Scaffold(
      // Tiêu đề của ứng dụng
      appBar: AppBar(
        // Tieu de
        title: Text("App 02"),
        // Mau nen
        backgroundColor: Colors.green,
        // Do nang/ do bong cua AppBar
        elevation: 4,
        actions: [
          IconButton( onPressed: (){print("b1");},
            icon: Icon(Icons.search),
          ),
          IconButton(onPressed: (){print("b2");},
            icon: Icon(Icons.abc),
          ),
          IconButton(onPressed: (){print("b3");},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(child: Text("Noi dung chinh")),
      floatingActionButton: FloatingActionButton(
        onPressed: () { print("pressend"); },
        child: const Icon(Icons.add_ic_call),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chu"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tim kiem"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Ca nhan"),
      ]),
    );
  }
}