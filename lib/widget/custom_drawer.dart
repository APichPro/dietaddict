import 'package:diet_junkie/design.dart';
import 'package:diet_junkie/page/add_page.dart';
import 'package:diet_junkie/page/calendar_page.dart';
import 'package:diet_junkie/page/height_page.dart';
import 'package:diet_junkie/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomDrawer extends HookConsumerWidget {
  CustomDrawer({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(context, WidgetRef ref) {
    return Drawer(
      backgroundColor: yellow50,
      width: 125,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            iconSize: 75,
            color: white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 75,
            color: white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPage()),
              );
            },
          ),
          IconButton(
            iconSize: 75,
            color: white,
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarPage()),
              );
            },
          ),
          IconButton(
            iconSize: 75,
            color: white,
            icon: Icon(Icons.query_stats),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HeightPage()),
              );
            },
          )
        ],
      ),
    );
  }
}
