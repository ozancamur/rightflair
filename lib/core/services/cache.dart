import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 3;

  /// Get recent searches from cache
  Future<List<String>> getRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList(_recentSearchesKey) ?? [];
      return searches;
    } catch (e) {
      return [];
    }
  }

  /// Save recent searches to cache (max 3)
  Future<void> saveRecentSearches(List<String> searches) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final limitedSearches = searches.take(_maxRecentSearches).toList();
      await prefs.setStringList(_recentSearchesKey, limitedSearches);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Add a single search to recent searches
  Future<void> addRecentSearch(String query) async {
    if (query.trim().isEmpty) return;

    final searches = await getRecentSearches();
    final updatedSearches = List<String>.from(searches);

    // Remove if already exists
    updatedSearches.remove(query);

    // Add to beginning
    updatedSearches.insert(0, query);

    // Keep only max 3 searches
    if (updatedSearches.length > _maxRecentSearches) {
      updatedSearches.removeRange(_maxRecentSearches, updatedSearches.length);
    }

    await saveRecentSearches(updatedSearches);
  }

  /// Remove a search from recent searches
  Future<void> removeRecentSearch(String query) async {
    final searches = await getRecentSearches();
    final updatedSearches = List<String>.from(searches);
    updatedSearches.remove(query);
    await saveRecentSearches(updatedSearches);
  }

  /// Clear all recent searches
  Future<void> clearRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentSearchesKey);
    } catch (e) {
      // Handle error silently
    }
  }
}
