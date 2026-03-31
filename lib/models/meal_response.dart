import 'package:food_recognizer_app/models/meal.dart';
import 'dart:convert';

class MealsResponse {
  final List<Meal> meals;
  MealsResponse({required this.meals});

  factory MealsResponse.fromRawJson(String str) =>
      MealsResponse.fromJson(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MealsResponse.fromJson(Map<String, dynamic> json) => MealsResponse(
    meals: json["meals"] == null
        ? []
        : List<Meal>.from(json["meals"]!.map((x) => Meal.fromJson(x))),
  );

  Map<String, dynamic> toMap() => {
    "meals": List<dynamic>.from(
      meals!.map(
        (x) => Map.from(x as Map<dynamic, dynamic>).map((k, v) => MapEntry<String, dynamic>(k, v)),
      ),
    ),
  };
}
