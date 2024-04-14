
import "package:flutter/material.dart";
import "package:my_stock_app/pages/compare_page.dart";
import "package:my_stock_app/pages/intro_page.dart";
import "package:my_stock_app/pages/stock_info_page.dart";

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;

  void _navigationBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [const IntroPage(), const StockInfoPage(), const ComparePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Stock App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: _selectedIndex,
        onTap: _navigationBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Intro"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Stock Info"),
          BottomNavigationBarItem(icon: Icon(Icons.compare_outlined), label: "Compare"),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}