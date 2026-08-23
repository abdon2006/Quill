import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/library/domain/entities/wishlist_entity.dart';

abstract class LibraryRemoteDataSource {
  Future<void> addToWishlist(String bookId);
  Future<void> removeFromWishlist(String bookId);
  Future<List<WishlistEntity>> fetchWishlist(NoParams params);
}
