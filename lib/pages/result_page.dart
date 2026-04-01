import 'package:flutter/material.dart';
import 'package:food_recognizer_app/controller/provider/search_food_provider.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  final Map<String, double> classificationResult;
  final String imagePath;

  const ResultPage({super.key, required this.classificationResult, required this.imagePath});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchFoodProvider>(
        context,
        listen: false,
      ).fetchFoodData(widget.classificationResult.entries.first.key);
    });
  }

  @override
  Widget build(BuildContext context) {
    final topEntry = widget.classificationResult.entries.isNotEmpty
        ? widget.classificationResult.entries.first
        : null;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Result Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: topEntry == null
              ? const Center(child: Text('No classification result'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      topEntry.key,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Confidence: ${(topEntry.value * 100).toStringAsFixed(1)}%',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Top predictions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...widget.classificationResult.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key, style: const TextStyle(fontSize: 16)),
                            Text('${(entry.value * 100).toStringAsFixed(1)}%', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
        ),
      ),
    );
  }
}