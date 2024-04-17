import 'package:flutter/material.dart';

class StockDetailPage extends StatefulWidget {
  final Map<String, dynamic> stock;

  const StockDetailPage({super.key, required this.stock});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.stock['stockName']} (${widget.stock['stockCode']})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoContainer('成交股數', widget.stock['volume'].toString(), Colors.blue[100]!, Colors.blue[200]!),
                const SizedBox(width: 16),
                _buildInfoContainer('成交金額', widget.stock['amount'].toString(), Colors.green[100]!, Colors.green[200]!),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoContainer('開盤價', widget.stock['openPrice'].toString(), Colors.red[100]!, Colors.red[200]!),
                const SizedBox(width: 16),
                _buildInfoContainer('收盤價', widget.stock['closePrice'].toString(), Colors.orange[100]!, Colors.orange[200]!),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoContainer('最高價', widget.stock['highPrice'].toString(), Colors.purple[100]!, Colors.purple[200]!),
                const SizedBox(width: 16),
                _buildInfoContainer('最低價', widget.stock['lowPrice'].toString(), Colors.teal[100]!, Colors.teal[200]!),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoContainer('漲跌價差', widget.stock['change'].toString(), Colors.pink[100]!, Colors.pink[200]!),
                const SizedBox(width: 16),
                _buildInfoContainer('成交筆數', widget.stock['transactionCount'].toString(), Colors.amber[100]!, Colors.amber[200]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String label, String value, Color startColor, Color endColor) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}