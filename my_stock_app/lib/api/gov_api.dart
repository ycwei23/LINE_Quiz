import 'package:http/http.dart' as http;

Future<void> call_api() async {
  var url = 'https://www.twse.com.tw/exchangeReport/STOCK_DAY_ALL?response=open_data';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // 如果伺服器回傳200 OK
    print(response.body);
    //return json.decode(response.body);
  } else {
    // 如果發生錯誤，拋出exception
    throw Exception('Failed to load data from API');
  }
}