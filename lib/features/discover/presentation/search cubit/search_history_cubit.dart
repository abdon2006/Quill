import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_history_state.dart';

class SearchHistoryCubit extends Cubit<SearchHistoryState> {
  SearchHistoryCubit() : super(SearchHistoryInitial());

  static const String _historyKey = 'history';
  static const int _maxHistoryLength = 5;

  // 1. تحميل الهيستوري من الكاش
  Future<void> loadHistory() async {
    try {
      emit(SearchHistoryLoading());
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_historyKey) ?? [];
      emit(SearchHistoryLoaded(history));
    } catch (e) {
      emit(SearchHistoryError(e.toString()));
    }
  }

  Future<void> saveSearch(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHistory = prefs.getStringList(_historyKey) ?? [];

      currentHistory.remove(trimmedQuery);
      currentHistory.insert(0, trimmedQuery);

      if (currentHistory.length > _maxHistoryLength) {
        currentHistory.removeLast();
      }

      await prefs.setStringList(_historyKey, currentHistory);
      emit(SearchHistoryLoaded(List.from(currentHistory)));
    } catch (e) {
      emit(SearchHistoryError(e.toString()));
    }
  }

  // 3. حذف كلمة معينة من الهيستوري
  Future<void> deleteSearch(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHistory = prefs.getStringList(_historyKey) ?? [];

      currentHistory.remove(query);

      await prefs.setStringList(_historyKey, currentHistory);
      emit(SearchHistoryLoaded(List.from(currentHistory)));
    } catch (e) {
      emit(SearchHistoryError(e.toString()));
    }
  }
}
