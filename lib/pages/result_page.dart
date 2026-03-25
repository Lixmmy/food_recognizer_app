import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    Scaffold(
      appBar: AppBar(
        title: const Text('Result Page'),
      ),
      body: Column(
       
        children: [
          Image(image: AssetImage('assets/picture/satay.jpg')),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Satay',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text(
                'Confidence: 95%',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Description:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

        ],
      ),
    ),);
  }
}