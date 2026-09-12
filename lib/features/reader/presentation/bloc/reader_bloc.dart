import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/network/network_service.dart';
import 'package:quill/features/home/data/models/book_model.dart';
import 'package:quill/features/reader/domain/usecases/fetch_local_book_usecase.dart';
import 'package:quill/features/reader/domain/usecases/fetch_local_books_usecase.dart';
import 'package:quill/features/reader/domain/usecases/remove_book_usecase.dart';
import 'package:quill/features/reader/domain/usecases/update_book_usecase.dart';
import 'package:quill/features/reader/domain/usecases/upload_book_usecase.dart';
import 'package:quill/features/reader/presentation/bloc/reader_event.dart';
import 'package:quill/features/reader/presentation/bloc/reader_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final UploadBookUsecase uploadBookUsecase;
  final RemoveBookUsecase removeBookUsecase;
  final FetchLocalBookUsecase fetchLocalBookUsecase;
  final UpdateBookUsecase updateBookUsecase;
  final FetchLocalBooksUsecase fetchLocalBooksUsecase;
  final NetworkService networkService;

  ReaderBloc({
    required this.uploadBookUsecase,
    required this.removeBookUsecase,
    required this.fetchLocalBookUsecase,
    required this.updateBookUsecase,
    required this.fetchLocalBooksUsecase,
    required this.networkService,
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

    on<FetchServerBookEvent>((event, emit) async {
      try {
        emit(ReaderLoading());
        final response = await networkService.dioGet(
          '/books/${event.bookId}/download',
          {},
        );
        final Map<String, dynamic> data = response.data['data'];
        final Map<String, dynamic> metaData = data['book'];
        final book = BookModel.fromJson(metaData);

        final List<String> paragraphs = (data['chunks'] as List)
            .map((chunk) => (chunk['content']) as String)
            .toList();
        if (paragraphs.isNotEmpty) {
          emit(FetchServerBookSuccess(paragraphs: paragraphs, book: book));
        } else {
          emit(
            ReaderFailure(
              failure: ServerFailure(message: 'Error Fetching Server Book'),
            ),
          );
        }
      } catch (e) {
        emit(ReaderFailure(failure: ServerFailure(message: e.toString())));
      }
    });

    on<FetchProgressEvent>((event, emit) async {
      try {
        emit(ReaderLoading());
        final prefs = await SharedPreferences.getInstance();
        final storedPercentage = prefs.getDouble(event.bookId);
        if (storedPercentage == null) {
          final response = await networkService.dioGet(
            '/reading/${event.bookId}',
            {},
          );

          final chunkIndex =
              response.data['data']['progress']['currentChunkIndex'];

          double percentage = (chunkIndex / event.totalChunks) * 100;

          prefs.setDouble(event.bookId, percentage);

          emit(FetchProgressSuccess(progress: percentage));
        } else {
          emit(FetchProgressSuccess(progress: storedPercentage));
        }
      } catch (e) {
        emit(ReaderFailure(failure: ServerFailure(message: e.toString())));
      }
    });
    

    on<UpdateServerProgressEvent>((event, emit) async {
      try {
        emit(ReaderLoading());
        final prefs = await SharedPreferences.getInstance();
        prefs.setDouble(event.bookId, event.progress);
        int chunkIndex = ((event.progress / 100) * event.totalChunks).floor();
        if (chunkIndex >= event.totalChunks) {
          chunkIndex = event.totalChunks - 1;
        }
        print('✅ Saved Locally: ${event.progress}%');
        print(
          '👻 Sending Ghost Request to Chunk: $chunkIndex to trigger backend logic...',
        );

        await networkService.dioGet(
          '/books/${event.bookId}/chunks/$chunkIndex',
          {},
        );
        emit(UpdateServerProgressSuccess());
      } catch (e) {
        emit(ReaderFailure(failure: ServerFailure(message: e.toString())));
      }
    });
  }
}
