import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';

abstract class LibraryRemoteDataSource {
  Future<void> addToWishlist(String bookId);
  Future<void> removeFromWishlist(String bookId);
  Future<List<BookEntity>> fetchWishlist(NoParams params);
}
