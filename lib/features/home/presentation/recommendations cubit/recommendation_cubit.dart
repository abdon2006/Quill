import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/domain/usecases/fetch_books_usecase.dart';
import 'package:quill/features/home/presentation/recommendations%20cubit/recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  final FetchBooksUsecase fetchBooksUsecase;
  RecommendationCubit({required this.fetchBooksUsecase})
    : super(RecommendationInitial());
  Future<void> getRecommendation(String bookId) async {
    emit(RecommendationLoading());
    final response = await fetchBooksUsecase(NoParams());
    response.fold((f) => emit(RecommendationError()), (books) {
      final booksCopy = List<BookEntity>.from(books);
      booksCopy.removeWhere((book) => book.id == bookId);
      booksCopy.shuffle();
      final finalBooks = booksCopy.take(5).toList();
      emit(RecommendationSuccess(books: finalBooks));
    });
  }
}
