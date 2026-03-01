import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 3;

  // Pending post keys
  static const String _pendingPostKey = 'pending_post_data';
  static const String _pendingPostTimestampKey = 'pending_post_timestamp';
  static const Duration _pendingPostExpiry = Duration(hours: 3);

  // Has published post key
  static const String _hasPublishedPostKey = 'has_published_post';

  /// Get whether the user has ever published a post (default: false)
  Future<bool> getHasPublishedPost() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_hasPublishedPostKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Set that the user has published a post
  Future<void> setHasPublishedPost(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasPublishedPostKey, value);
    } catch (e) {
      // Handle error silently
    }
  }

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

  // ==================== Pending Post (Continue Editing) ====================

  /// Save pending post data to cache with current timestamp
  Future<void> savePendingPost(Map<String, dynamic> postData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(postData);
      await prefs.setString(_pendingPostKey, encoded);
      await prefs.setInt(
        _pendingPostTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      // ignore: avoid_print
      print(
        '[ContinueEditing] CacheService.savePendingPost: SUCCESS, key=$_pendingPostKey',
      );
    } catch (e) {
      // ignore: avoid_print
      print('[ContinueEditing] CacheService.savePendingPost: ERROR $e');
    }
  }

  /// Get pending post data if it exists and hasn't expired (within 3 hours)
  Future<Map<String, dynamic>?> getPendingPost() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_pendingPostKey);
      final timestamp = prefs.getInt(_pendingPostTimestampKey);

      // ignore: avoid_print
      print(
        '[ContinueEditing] CacheService.getPendingPost: raw=${raw != null ? 'exists (${raw.length} chars)' : 'null'}, timestamp=$timestamp',
      );

      if (raw == null || timestamp == null) return null;

      final savedAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      // Check if expired (more than 3 hours)
      if (now.difference(savedAt) > _pendingPostExpiry) {
        // ignore: avoid_print
        print(
          '[ContinueEditing] CacheService.getPendingPost: EXPIRED (saved at $savedAt)',
        );
        await clearPendingPost();
        return null;
      }

      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (e) {
      // ignore: avoid_print
      print('[ContinueEditing] CacheService.getPendingPost: ERROR $e');
      return null;
    }
  }

  /// Check if there is a valid (non-expired) pending post
  Future<bool> hasPendingPost() async {
    final data = await getPendingPost();
    return data != null;
  }

  /// Clear pending post data
  Future<void> clearPendingPost() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingPostKey);
      await prefs.remove(_pendingPostTimestampKey);
    } catch (e) {
      // Handle error silently
    }
  }

  // ==================== Generic Cache (Dynamic) ====================

  /// Read: Get cached JSON string by key
  Future<dynamic> get(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null) return null;
      return jsonDecode(raw);
    } catch (e) {
      return null;
    }
  }

  /// Create / Update: Save any value as JSON by key
  Future<bool> set(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(key, jsonEncode(value));
    } catch (e) {
      return false;
    }
  }

  /// Delete: Remove a cached value by key
  Future<bool> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(key);
    } catch (e) {
      return false;
    }
  }

  /// Check if a key exists in cache
  Future<bool> has(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  /// Clear all cache
  Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      return false;
    }
  }
}
