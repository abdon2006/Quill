import 'package:isar/isar.dart';
part 'wishlist_cache.g.dart';

@collection
class WishlistCache {
  Id isarID = Isar.autoIncrement;
  late String wishlistId;
  late String bookId;
  late String userId;
  late String author;
  late String title;
  late String coverImage;
  late double ratingAvg;
}
