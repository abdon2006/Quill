import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/features/reader/domain/usecases/fetch_local_book_usecase.dart';
import 'package:quill/features/reader/domain/usecases/fetch_local_books_usecase.dart';
import 'package:quill/features/reader/domain/usecases/remove_book_usecase.dart';
import 'package:quill/features/reader/domain/usecases/update_book_usecase.dart';
import 'package:quill/features/reader/domain/usecases/upload_book_usecase.dart';
import 'package:quill/features/reader/presentation/bloc/reader_event.dart';
import 'package:quill/features/reader/presentation/bloc/reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final UploadBookUsecase uploadBookUsecase;
  final RemoveBookUsecase removeBookUsecase;
  final FetchLocalBookUsecase fetchLocalBookUsecase;
  final UpdateBookUsecase updateBookUsecase;
  final FetchLocalBooksUsecase fetchLocalBooksUsecase;

  ReaderBloc({
    required this.uploadBookUsecase,
    required this.removeBookUsecase,
    required this.fetchLocalBookUsecase,
    required this.updateBookUsecase,
    required this.fetchLocalBooksUsecase,
  }) : super(ReaderInitial()) {
    on<UploadBookEvent>((event, emit) async {
      emit(ReaderLoading());
      final response = await uploadBookUsecase(event.book);
      response.fold((failure) => emit(ReaderFailure(failure: failure)), (
        success,
      ) {
        emit(UploadBookSuccess());
        add(FetchLocalBooksEvent());
      });
    });

    on<RemoveBookEvent>((event, emit) async {
      emit(ReaderLoading());
      final response = await removeBookUsecase(event.bookId);
      response.fold((failure) => emit(ReaderFailure(failure: failure)), (
        success,
      ) {
        emit(RemoveBookSuccess());
        add(FetchLocalBooksEvent());
      });
    });

    on<FetchLocalBookEvent>((event, emit) async {
      emit(ReaderLoading());
      final response = await fetchLocalBookUsecase(event.bookId);
      response.fold(
        (failure) => emit(ReaderFailure(failure: failure)),
        (book) => emit(FetchLocalBookSuccess(book: book)),
      );
    });

    on<UpdateBookEvent>((event, emit) async {
      final response = await updateBookUsecase(event.params);
      response.fold((failure) => emit(ReaderFailure(failure: failure)), (
        success,
      ) {
        emit(UpdateBookSuccess());
        add(FetchLocalBooksEvent());
      });
    });
    on<FetchLocalBooksEvent>((event, emit) async {
      final response = await fetchLocalBooksUsecase();
      response.fold(
        (failure) => emit(ReaderFailure(failure: failure)),
        (books) => emit(FetchLocalBooksSuccess(localBooks: books)),
      );
    });
  }
}
