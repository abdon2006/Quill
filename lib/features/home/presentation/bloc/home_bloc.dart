import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/home/domain/repositories/book_repository.dart';
import 'package:quill/features/home/domain/usecases/fetch_books_usecase.dart';
import 'package:quill/features/home/domain/usecases/get_book_by_id_usecase.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetBookByIdUsecase getBookByIdUsecase;
  final BookRepository bookRepository;
  final FetchBooksUsecase fetchBooksUsecase;

  HomeBloc({
    required this.fetchBooksUsecase,
    required this.bookRepository,
    required this.getBookByIdUsecase,
  }) : super(HomeInitial()) {
    on<FetchHomeBooksEvent>((event, emit) async {
      final isCached = await bookRepository.isCached();
      if (!isCached) emit(HomeLoading());
      final response = await fetchBooksUsecase(NoParams());
      if (response.isLeft()) {
        print('in the home bloc');
        final failure = response.fold((f) => f, (_) => null)!;
        await _handleFailure(emit, failure, isCached);
      } else {
        final books = response.fold((_) => null, (r) => r)!;
        emit(FetchBooksSuccess(books: books));
      }
    });

    on<RefreshBookEvent>((event, emit) async {
      emit(HomeLoading());
      final response = await bookRepository.refreshBooks();
      if (response.isLeft()) {
        final failure = response.fold((f) => f, (_) => null)!;
        await _handleFailure(emit, failure, false);
      } else {
        final books = response.fold((_) => null, (r) => r)!;
        emit(FetchBooksSuccess(books: books));
      }
    });

    on<GetBookByIdEvent>((event, emit) async {
      emit(HomeLoading());
      final response = await getBookByIdUsecase(event.bookId);
      if (response.isLeft()) {
        final failure = response.fold((f) => f, (_) => null)!;
        await _handleFailure(emit, failure, false);
      } else {
        final book = response.fold((_) => null, (r) => r)!;
        emit(GetBookByIdSuccess(book: book));
      }
    });
  }

  Future<void> _handleFailure(
    Emitter<HomeState> emit,
    Failure failure,
    bool isCached,
  ) async {
    if (!isCached) {
      final cachedBooks = await bookRepository.getCachedBooks();
      print('CACHED BOOKS : $cachedBooks');
      emit(
        HomeError(
          failure: failure,
          cachedBooks: cachedBooks.isEmpty ? null : cachedBooks,
        ),
      );
    }
  }
}
