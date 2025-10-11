import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Singleton service for managing quiz data across the app
/// Handles loading, caching, and providing quiz data efficiently
class QuizDataManager {
  // Singleton pattern
  static final QuizDataManager _instance = QuizDataManager._internal();
  factory QuizDataManager() => _instance;
  QuizDataManager._internal();

  // Cache storage
  final Map<String, Map<String, dynamic>> _quizCache = {};
  final Map<String, bool> _loadingState = {};

  /// Loads quiz data for a specific story
  /// Returns cached data if available, otherwise loads from assets
  ///
  /// [quizPath] - Asset path to the quiz JSON file
  /// [forceReload] - If true, bypasses cache and reloads from assets
  Future<Map<String, dynamic>> loadQuizData(
      String quizPath, {
        bool forceReload = false,
      }) async {
    // Return cached data if available and not forcing reload
    if (!forceReload && _quizCache.containsKey(quizPath)) {
      return _quizCache[quizPath]!;
    }

    // Prevent duplicate loading requests
    if (_loadingState[quizPath] == true) {
      // Wait for existing load to complete
      await Future.delayed(const Duration(milliseconds: 100));
      return loadQuizData(quizPath, forceReload: false);
    }

    try {
      _loadingState[quizPath] = true;

      // Load and parse JSON
      final jsonString = await rootBundle.loadString(quizPath);

      // Use compute for heavy parsing (runs in isolate)
      final data = await compute(_parseJsonInIsolate, jsonString);

      // Cache the result
      _quizCache[quizPath] = data;

      return data;
    } catch (e) {
      debugPrint('Error loading quiz data from $quizPath: $e');
      rethrow;
    } finally {
      _loadingState[quizPath] = false;
    }
  }

  /// Preloads quiz data in the background
  /// Use this when you know a quiz will be needed soon
  Future<void> preloadQuizData(String quizPath) async {
    try {
      await loadQuizData(quizPath);
      debugPrint('✅ Preloaded quiz data: $quizPath');
    } catch (e) {
      debugPrint('⚠️ Failed to preload quiz data: $e');
    }
  }

  /// Gets cached quiz data synchronously (returns null if not cached)
  Map<String, dynamic>? getCachedQuizData(String quizPath) {
    return _quizCache[quizPath];
  }

  /// Checks if quiz data is already cached
  bool isCached(String quizPath) {
    return _quizCache.containsKey(quizPath);
  }

  /// Clears a specific quiz from cache
  void clearQuiz(String quizPath) {
    _quizCache.remove(quizPath);
    debugPrint('Cleared cache for: $quizPath');
  }

  /// Clears all cached quiz data
  void clearAll() {
    _quizCache.clear();
    debugPrint('Cleared all quiz cache');
  }

  /// Gets the total number of cached quizzes
  int get cacheSize => _quizCache.length;

  /// Static method for parsing JSON in an isolate
  static Map<String, dynamic> _parseJsonInIsolate(String jsonString) {
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Preloads multiple quizzes at once
  Future<void> preloadMultipleQuizzes(List<String> quizPaths) async {
    await Future.wait(
      quizPaths.map((path) => preloadQuizData(path)),
    );
  }
}

/// Extension for common quiz paths (optional convenience)
extension QuizPaths on QuizDataManager {
  static const String alamatNgPinya = 'assets/data/quizzes/alamat-ng-pinya-quiz.json';
// Add more quiz paths as needed
// static const String anotherQuiz = 'assets/data/quizzes/another-quiz.json';
}