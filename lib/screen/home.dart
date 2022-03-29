import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:geforcedom/screen/PageLocation.dart';
import 'package:geforcedom/screen/PageProfile.dart';
import 'package:geforcedom/screen/home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List pages = [HomeScreen(), PageLocation(), PageProfile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Ge",
              style: TextStyle(fontSize: 22, color: Colors.orange),
            ),
            Text(
              "force",
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        onItemSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.orange,
            inactiveColor: Colors.deepOrangeAccent,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.location_pin),
            title: Text('Location'),
            activeColor: Colors.orange,
            inactiveColor: Colors.deepOrangeAccent,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            activeColor: Colors.orange,
            inactiveColor: Colors.deepOrangeAccent,
          ),
        ],
      ),
    );
  }
}
