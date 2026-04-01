import 'package:food_recognizer_app/models/meal.dart';

class MealsResponse {
  final List<Meal> meals;
  MealsResponse({required this.meals});

  factory MealsResponse.fromJson(Map<String, dynamic> json) => MealsResponse(
    meals: json["meals"] == null
        ? []
        : List<Meal>.from(json["meals"]!.map((x) => Meal.fromJson(x))),
  );

 Map<String, dynamic> toJson() => {
    "meals": meals.isEmpty
        ? []
        : List<dynamic>.from(meals.map((x) => x.toJson())),
  };
}
