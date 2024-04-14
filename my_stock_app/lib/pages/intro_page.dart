import 'package:flutter/material.dart';
import 'package:my_stock_app/api/gov_api.dart';
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: IconButton(icon: Icon(Icons.send), onPressed: call_api,),),
    );
  }
}