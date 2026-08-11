import 'package:quill/features/library/domain/Entities/wishlist_entity.dart';

class WishlistModel extends WishlistEntity {
  const WishlistModel({
    required super.wishlistId,
    required super.bookId,
    required super.userId,
    required super.author,
    required super.title,
    required super.coverImage,
    required super.ratingAvg,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    final bookData = json['bookId'];
    return WishlistModel(
      wishlistId: json['_id'],
      userId: json['userId'],
      bookId: bookData['_id'],
      author: bookData['author'],
      title: bookData['title'],
      coverImage: bookData['coverImage'],
      ratingAvg: (bookData['ratingsAverage'] as num).toDouble(),
    );
  }
}
