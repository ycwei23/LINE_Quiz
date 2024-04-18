import 'package:flutter/material.dart';
import 'compare_result_page.dart';

class SelectOptionPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedStocks;

  const SelectOptionPage({super.key, required this.selectedStocks});

  @override
  State<SelectOptionPage> createState() => _SelectOptionPageState();
}

class _SelectOptionPageState extends State<SelectOptionPage> {
  final List<String> _options = [
    'volume',
    'amount',
    'highPrice',
    'lowPrice',
    'openPrice',
    'closePrice',
    'change',
    'transactionCount',
  ];
  final List<String> _chinese_options = [
    '成交股數',
    '成交金額',
    '最高價',
    '最低價',
    '開盤價',
    '收盤價',
    '漲跌價差',
    '成交筆數',
  ];
  final List<bool> _selectedOptions = List.generate(8, (_) => false);

  void _toggleOption(int index) {
    setState(() {
      _selectedOptions[index] = !_selectedOptions[index];
    });
  }

  void _navigateToCompareResultPage() {
    final List<String> selectedOptions = [];
    for (var i = 0; i < _selectedOptions.length; i++) {
      if (_selectedOptions[i]) {
        selectedOptions.add(_options[i]);
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompareResultPage(
          selectedStocks: widget.selectedStocks,
          selectedOptions: selectedOptions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('請選擇要比較的項目'),
      ),
      body: ListView.builder(
        itemCount: _options.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(_chinese_options[index]),
            value: _selectedOptions[index],
            onChanged: (value) => _toggleOption(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCompareResultPage,
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}