import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/features/reader/domain/usecases/fetch_local_book_usecase.dart';
import 'package:quill/features/reader/domain/usecases/fetch_local_books_usecase.dart';
import 'package:quill/features/reader/domain/usecases/remove_book_usecase.dart';
import 'package:quill/features/reader/domain/usecases/update_progress_usecase.dart';
import 'package:quill/features/reader/domain/usecases/upload_book_usecase.dart';
import 'package:quill/features/reader/presentation/bloc/reader_event.dart';
import 'package:quill/features/reader/presentation/bloc/reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final UploadBookUsecase uploadBookUsecase;
  final RemoveBookUsecase removeBookUsecase;
  final FetchLocalBookUsecase fetchLocalBookUsecase;
  final UpdateProgressUsecase updateProgressUsecase;
  final FetchLocalBooksUsecase fetchLocalBooksUsecase;

  ReaderBloc({
    required this.uploadBookUsecase,
    required this.removeBookUsecase,
    required this.fetchLocalBookUsecase,
    required this.updateProgressUsecase,
    required this.fetchLocalBooksUsecase,
  }) : super(ReaderInitial()) {
    on<UploadBookEvent>((event, emit) async {
      emit(ReaderLoading());
      final response = await uploadBookUsecase(event.book);
      response.fold(
        (failure) => emit(ReaderFailure(failure: failure)),
        (success) => emit(UploadBookSuccess()),
      );
    });

    on<RemoveBookEvent>((event, emit) async {
      emit(ReaderLoading());
      final response = await removeBookUsecase(event.bookId);
      response.fold(
        (failure) => emit(ReaderFailure(failure: failure)),
        (success) => emit(RemoveBookSuccess()),
      );
    });

    on<FetchLocalBookEvent>((event, emit) async {
      emit(ReaderLoading());
      final response = await fetchLocalBookUsecase(event.bookId);
      response.fold(
        (failure) => emit(ReaderFailure(failure: failure)),
        (book) => emit(FetchLocalBookSuccess(book: book)),
      );
    });

    on<UpdateBookProgressEvent>((event, emit) async {
      final response = await updateProgressUsecase(event.bookId, event.newPage);
      response.fold(
        (failure) => emit(ReaderFailure(failure: failure)),
        (success) => emit(UpdateBookProgressSuccess()),
      );
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
