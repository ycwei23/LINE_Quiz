import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_stock_app/database/database_helper.dart';
import 'package:my_stock_app/pages/stock_detail.page.dart';

class StockInfoPage extends StatefulWidget {
  const StockInfoPage({super.key});

  @override
  State<StockInfoPage> createState() => _StockInfoPageState();
}

class _StockInfoPageState extends State<StockInfoPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResult = [];
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

  void _navigateToStockDetail(String stockCode) async {
    final stock = await DatabaseHelper.instance.getStockByCode(stockCode);
    if (stock != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StockDetailPage(stock: stock),
        ),
      );
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
                    onTap: () => _navigateToStockDetail(stock['stockCode']),
                  ),
                  color: Colors.blue[100],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}