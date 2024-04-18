import "package:flutter/material.dart";
import "package:my_stock_app/pages/compare_page.dart";
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

  final List _pages = [const StockInfoPage(), const ComparePage()];

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('功能介紹'),
          content: const Text(
            '搜尋股票: 在此頁面中,您可以搜尋感興趣的股票,並查看其當日的詳細資訊。\n\n'
            '比較股票: 在此頁面中,您可以選擇多支股票進行比較,分析它們當日在不同指標上的表現。',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "當日股票小程式",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigationBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "搜尋股票"),
          BottomNavigationBarItem(icon: Icon(Icons.compare_rounded), label: "比較股票"),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}