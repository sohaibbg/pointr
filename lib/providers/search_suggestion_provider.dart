import 'package:flutter/material.dart';
import 'package:pointr/classes/google_api.dart';
import 'package:pointr/classes/google_place.dart';

class SearchSuggestionProvider with ChangeNotifier {
  List<GooglePlace> _suggestions = [];
  List<GooglePlace> get suggestions => _suggestions;
  Future<void> fetchSuggestions(BuildContext? context, String term) async {
    _suggestions.clear();
    // from g places api
    List<GooglePlace> results;
    if (term.trim().isEmpty) {
      results = [];
    } else {
      results = await GoogleApi.autocomplete(term.trim());
    }
    _suggestions.addAll(results);
    notifyListeners();
  }

  void clear() {
    _suggestions = [];
    notifyListeners();
  }
}
