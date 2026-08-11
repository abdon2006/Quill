import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/library/domain/UseCases/add_to_wishlist.dart';
import 'package:quill/features/library/domain/UseCases/fetch_wishlist.dart';
import 'package:quill/features/library/domain/UseCases/remove_from_wishlist.dart';
import 'package:quill/features/library/presentation/bloc/library_event.dart';
import 'package:quill/features/library/presentation/bloc/library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final AddToWishlistUsecase addToWishlistUsecase;
  final RemoveFromWishlistUsecase removeFromWishlistUsecase;
  final FetchWishlistUsecase fetchWishlistUsecase;
  LibraryBloc({
    required this.addToWishlistUsecase,
    required this.removeFromWishlistUsecase,
    required this.fetchWishlistUsecase,
  }) : super(LibraryInitial()) {
    on<AddToWishlistEvent>((event, emit) async {
      emit(LibraryLoading());
      final response = await addToWishlistUsecase(event.bookId);
      response.fold(
        (failure) => emit(LibraryError(failure: failure)),
        (success) => emit(AddSuccessState()),
      );
    });
    on<RemoveFromWishlistEvent>((event, emit) async {
      emit(LibraryLoading());
      final response = await removeFromWishlistUsecase(event.bookId);
      response.fold(
        (failure) => emit(LibraryError(failure: failure)),
        (success) => emit(RemoveSuccessState()),
      );
    });
    on<FetchWishlistEvent>((event, emit) async {
      emit(LibraryLoading());
      final response = await fetchWishlistUsecase(NoParams());
      response.fold(
        (failure) => emit(LibraryError(failure: failure)),
        (success) => emit(FetchSuccessState(books: success)),
      );
    });
  }
}
