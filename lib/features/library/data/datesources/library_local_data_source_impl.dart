import 'package:isar/isar.dart';
import 'package:quill/features/library/data/datesources/library_local_data_source.dart';
import 'package:quill/features/library/data/models/wishlist_cache.dart';

class LibraryLocalDataSourceImpl implements LibraryLocalDataSource {
  final Isar isarInstance;

  LibraryLocalDataSourceImpl({required this.isarInstance});
  @override
  Future<void> cacheWishlist(List<WishlistCache> books) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.wishlistCaches.clear();
      await isarInstance.wishlistCaches.putAll(books);
    });
  }

  @override
  Future<List<WishlistCache>> fetchWishlist() async {
    return await isarInstance.wishlistCaches.where().findAll();
  }

  @override
  Future<void> removeFromCache(String bookId) async {
    await isarInstance.writeTxn(() async {
      final item = await isarInstance.wishlistCaches
          .filter()
          .bookIdEqualTo(bookId)
          .findFirst();
      if (item != null) {
        await isarInstance.wishlistCaches.delete(item.isarID);
      }
    });
  }
}
