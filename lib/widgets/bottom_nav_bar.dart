import 'package:flutter/material.dart';
import 'package:pointr/my_theme.dart';
import 'package:pointr/screens/home.dart';

class BNavScaffold extends StatefulWidget {
  const BNavScaffold({required this.index, super.key});
  final int index;
  @override
  State<BNavScaffold> createState() => _BNavScaffoldState();
}

class _BNavScaffoldState extends State<BNavScaffold> {
  static late int index;
  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  // static const List<Widget> screens = [Home(), Routes()];
  static const List<Widget> screens = [Home(), SizedBox()];
  void onItemTapped(int selectedIndex) => setState(() => index = selectedIndex);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: screens.elementAt(index),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Add Route'),
          ],
          selectedItemColor: MyTheme.colorPrimary,
          onTap: onItemTapped,
        ),
      );
}
