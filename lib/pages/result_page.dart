import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final Map<String, double> classificationResult;

  const ResultPage({super.key, required this.classificationResult});

  @override
  Widget build(BuildContext context) {
    final topEntry = classificationResult.entries.isNotEmpty
        ? classificationResult.entries.first
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
                    ...classificationResult.entries.map((entry) {
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