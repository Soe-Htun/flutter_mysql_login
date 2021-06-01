import 'package:flutter/material.dart';
import 'package:mysql_login/constant.dart';
import 'package:mysql_login/main/details/details.dart';
import 'package:mysql_login/main/home/home.dart';

class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageIndex =0;
    @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome",),
        backgroundColor: kDrawerColor,
      ),
      drawer: Drawer(),
      body: pageIndex == 0? Home() : Details(),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: kDrawerColor,
        currentIndex: pageIndex ,
        onTap: (index){
          setState(() {
            pageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: "Details"
          )
        ],
      ),
    );
  }
}