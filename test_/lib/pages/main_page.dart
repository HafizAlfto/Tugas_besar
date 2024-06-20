import 'package:flutter/material.dart';
import 'package:test_/pages/home_page.dart';
import 'package:test_/pages/person_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;
  Widget body() {
    switch (currentPage) {
      case 0:
        return const HomePage();
      case 1:
        return const PersonPage();
      default:
        return const Text('Something Wrong!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF5EC6F9),
          currentIndex: currentPage,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: ''),
          ]),
    );
  }
}
