import 'package:flutter/material.dart';
import 'package:my_stock_app/api/gov_api.dart';
import 'package:my_stock_app/database/database_helper.dart';
import 'package:my_stock_app/pages/base_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // 確保Flutter環境初始化
  await loadingData();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BasePage(),
  ));
}

Future<void> loadingData() async {
  final dbHelper = DatabaseHelper.instance;
  // 清空資料庫
  await dbHelper.clearDatabase();
  // 呼叫API取得新資料
  final stockData = await callApi();
  
  // 將新資料插入資料庫
  await dbHelper.insertStockData(stockData);
}

