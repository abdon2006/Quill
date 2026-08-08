import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/home/domain/repositories/book_repository.dart';
import 'package:quill/features/home/domain/usecases/fetch_books_usecase.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BookRepository bookRepository;
  final FetchBooksUsecase fetchBooksUsecase;

  HomeBloc({required this.fetchBooksUsecase, required this.bookRepository})
    : super(HomeInitial()) {
    on<FetchHomeBooksEvent>((event, emit) async {
      final isCached = await bookRepository.isCacheValid();
      if (!isCached) emit(HomeLoading());
      final response = await fetchBooksUsecase(NoParams());
      response.fold(
        (failure) => emit(HomeError(message: failure.message)),
        (books) => emit(FetchBooksSuccess(books: books)),
      );
    });
  }
}
