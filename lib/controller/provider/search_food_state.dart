import 'package:food_recognizer_app/models/meal_response.dart';

sealed class SearchFoodState {}

final class SearchFoodInitial extends SearchFoodState {}

final class SearchFoodLoading extends SearchFoodState {}

final class SearchFoodSuccess extends SearchFoodState {
  final MealsResponse meals;

  SearchFoodSuccess({required this.meals});
}

final class SearchFoodFailure extends SearchFoodState {
  final String message;

  SearchFoodFailure({required this.message});
}
