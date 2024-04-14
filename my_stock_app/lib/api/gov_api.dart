import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> callApi() async {
  var url = 'https://www.twse.com.tw/exchangeReport/STOCK_DAY_ALL?response=open_data';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final decodedData = utf8.decode(response.bodyBytes);
    final dataList = decodedData.split('\n');
    final List<Map<String, dynamic>> stockData = [];

    for (var i = 1; i < dataList.length - 1; i++) {
      final rowData = dataList[i].split('","');
      try {
        final data = {
          'stockCode': rowData[0].replaceAll('"', ''),
          'stockName': rowData[1],
          'volume': double.tryParse(rowData[2].replaceAll(',', '')) ?? 0,
          'amount': double.tryParse(rowData[3].replaceAll(',', '')) ?? 0,
          'openPrice': double.tryParse(rowData[4]) ?? 0.0,
          'highPrice': double.tryParse(rowData[5]) ?? 0.0,
          'lowPrice': double.tryParse(rowData[6]) ?? 0.0,
          'closePrice': double.tryParse(rowData[7]) ?? 0.0,
          'change': double.tryParse(rowData[8]) ?? 0.0,
          'transactionCount': double.tryParse(rowData[9].replaceAll('"', '')) ?? 0,
        };
        stockData.add(data);
      } catch (e) {
        print('Error parsing data for row $i: $e');
        // Optionally, continue to the next row or handle the error as needed
      }
    }

    return stockData;
  } else {
    throw Exception('Failed to load data from API');
  }
}
