import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_stock_app/database/database_helper.dart';
import 'package:my_stock_app/pages/select_option_page.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResult = [];
  List<Map<String, dynamic>> _selectedStocks = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchStocks();
    });
  }

  void _searchStocks() async {
    final keyword = _searchController.text;
    final result = await DatabaseHelper.instance.selectByCodeOrName(keyword);
    setState(() {
      _searchResult = result;
    });
  }


  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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

  void _selectStock(Map<String, dynamic> stock) {
    setState(() {
      if (_selectedStocks.length < 4) {
        final isStockSelected = _selectedStocks.any(
          (selectedStock) => selectedStock['stockCode'] == stock['stockCode'],
        );
        if (isStockSelected) {
          _showAlertDialog('提示', '該股票已經被選擇了');
        } else {
          _selectedStocks.add(stock);
        }
      } else {
        _showAlertDialog('提示', '最多只能選擇四個股票');
      }
    });
  }

  void _removeStock(Map<String, dynamic> stock) {
    setState(() {
      _selectedStocks.remove(stock);
    });
  }

  void _navigateToSelectOptionPage() {
    if (_selectedStocks.length >= 2 && _selectedStocks.length <= 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectOptionPage(
            selectedStocks: _selectedStocks,
          ),
        ),
      );
    } else {
      _showAlertDialog('提示', '請選擇至少兩個且最多四個股票');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜尋「股票名稱」或「股票代碼」',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: _selectedStocks.map((stock) {
              return Chip(
                label: Text(stock['stockCode']),
                onDeleted: () => _removeStock(stock),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, index) {
                final stock = _searchResult[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      stock['stockName'],
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      stock['stockCode'],
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () => _selectStock(stock),
                  ),
                  color: Colors.blue[100],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToSelectOptionPage,
        child: const Icon(Icons.navigate_next)
      ),
    );
  }
}