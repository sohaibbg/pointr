import 'package:flutter/material.dart';
import 'package:pointr/classes/google_api.dart';
import 'package:pointr/classes/place.dart';
import 'package:pointr/providers/star_provider.dart';
import 'package:provider/provider.dart';

class SearchSuggestionProvider with ChangeNotifier {
  List<Place> _suggestions = [];
  List<Place> get suggestions => _suggestions;
  Future<void> fetchSuggestions(BuildContext? context, String term) async {
    // from g places api
    List<Place> results = await GoogleApi.autocomplete(term);
    _suggestions.addAll(results);
    // from starred places
    // TODO assert starProvider is provided before this method is ever called
    if (context != null) {
      if (context.mounted) {
        results = Provider.of<StarProvider>(context, listen: false).all;
        _suggestions.addAll(results);
      }
    }
    _suggestions.removeWhere(
      (sugg) => sugg.title.trim().contains(term.trim()),
    );
    notifyListeners();
  }

  void clear() {
    _suggestions = [];
    notifyListeners();
  }
}
