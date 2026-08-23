import 'package:quill/features/library/data/models/wishlist_cache.dart';

abstract class LibraryLocalDataSource {
  Future<List<WishlistCache>> fetchWishlist();
  Future<void> cacheWishlist(List<WishlistCache> books);
  Future<void> removeFromCache(String bookId);
}
