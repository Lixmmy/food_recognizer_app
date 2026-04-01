import 'package:flutter/foundation.dart';
import 'package:food_recognizer_app/controller/provider/search_food_state.dart';
import 'package:food_recognizer_app/service/api_service.dart';

class SearchFoodProvider extends ChangeNotifier {
  final ApiService _apiService;
  String _query = '';
  String? _errorMessage;
  SearchFoodState _state = SearchFoodInitial();

  String get getQuerry => _query;
  SearchFoodState get state => _state;
  String? get errorMessage => _errorMessage;

  SearchFoodProvider(this._apiService);

  Future<void> fetchFoodData(String query) async {
    _query = query;
    try {
      _state = SearchFoodLoading();
      notifyListeners();

      final data = await _apiService.getClassificationName(query);
      _state = SearchFoodSuccess(meals: data);
      notifyListeners();
    } catch (e) {
      _state = SearchFoodFailure(message: e.toString());
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
