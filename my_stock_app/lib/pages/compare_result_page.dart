import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CompareResultPage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedStocks;
  final List<String> selectedOptions;

  const CompareResultPage({
    super.key,
    required this.selectedStocks,
    required this.selectedOptions,
  });

  static const Map<String, String> _optionMap = {
    'volume': '成交股數',
    'amount': '成交金額',
    'highPrice': '最高價',
    'lowPrice': '最低價',
    'openPrice': '開盤價',
    'closePrice': '收盤價',
    'change': '漲跌價差',
    'transactionCount': '成交筆數',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('比較結果'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: selectedOptions.map((option) {
            return Column(
              children: [
                Text(
                  _optionMap[option]!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 1.7,
                  child: BarChart(
                    BarChartData(
                      barGroups: _createBarGroups(option),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: _createBottomTitles(),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: _createLeftTitles(option),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              rod.toY.toString(),
                              const TextStyle(color: Colors.white, fontSize: 16),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups(String option) {
    List<BarChartGroupData> barGroups = [];

    for (var i = 0; i < selectedStocks.length; i++) {
      final stock = selectedStocks[i];
      final dynamic value = stock[option];

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value?.toDouble() ?? 0.0,
              color: _getBarColor(value),
              width: 32,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  SideTitles _createBottomTitles() {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        final stock = selectedStocks[value.toInt()];
        final stockName = stock['stockName'] as String;

        return SideTitleWidget(
          axisSide: meta.axisSide,
          space: 8,
          child: Text(
            stockName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  SideTitles _createLeftTitles(String option) {
    final values = selectedStocks.map((stock) => stock[option] as num).toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return SideTitles(
      showTitles: true,
      interval: (maxValue / 5).ceil().toDouble(),
      reservedSize: 40,
      getTitlesWidget: (value, meta) {
        String text;
        if (value >= 1000000000) {
          text = '${(value / 1000000000).toStringAsFixed(1)}B';
        } else if (value >= 1000000) {
          text = '${(value / 1000000).toStringAsFixed(1)}M';
        } else if (value >= 1000) {
          text = '${(value / 1000).toStringAsFixed(1)}K';
        } else {
          text = value.toStringAsFixed(0);
        }

        return Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          textAlign: TextAlign.right,
        );
      },
    );
  }

  Color _getBarColor(num value) {
    if (value < 1000000) {
      return Colors.red;
    } else if (value < 5000000) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}