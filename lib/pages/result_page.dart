import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recognizer_app/controller/provider/search_food_provider.dart';
import 'package:food_recognizer_app/controller/provider/search_food_state.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  final Map<String, double> classificationResult;
  final String imagePath;

  const ResultPage({
    super.key,
    required this.classificationResult,
    required this.imagePath,
  });

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
        appBar: AppBar(title: const Text('Result Page')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: topEntry == null
                ? const Center(child: Text('No classification result'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.file(
                        File(widget.imagePath),
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text("Prediction"),
                      Divider(),
                      Row(
                        mainAxisAlignment: .spaceAround,
                        children: [
                          Text(
                            topEntry.key,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${(topEntry.value * 100).toStringAsFixed(1)}%',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Consumer<SearchFoodProvider>(
                        builder: (context, provider, child) {
                          final state = provider.state;
                          if (state is SearchFoodLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is SearchFoodFailure) {
                            return Center(
                              child: Text(
                                provider.errorMessage ?? 'An error occurred',
                              ),
                            );
                          } else if (state is SearchFoodSuccess) {
                            final food = state.meals.meals;
                            if (food.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 16.0),
                                child: Center(
                                  child: Text('Data makanan tidak ditemukan'),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Reference Information:",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Name: ${food.first.strMeal}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "Category: ${food.first.strCategory ?? 'N/A'}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "Area: ${food.first.strArea ?? 'N/A'}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Divider(),
                                  Text(
                                    "Instructions:",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    food.first.strInstructions ?? 'N/A',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Divider(),
                                  Text(
                                    "Ingredients:",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(20, (index) {
                                      final ingredient = food.first
                                          .toJson()['strIngredient${index + 1}'];
                                      final measure = food.first
                                          .toJson()['strMeasure${index + 1}'];
                                      if (ingredient != null &&
                                          ingredient.toString().isNotEmpty) {
                                        return Text(
                                          '- ${measure ?? ''} ${ingredient.toString()}',
                                          style: const TextStyle(fontSize: 18),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
