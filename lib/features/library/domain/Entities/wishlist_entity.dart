import 'package:equatable/equatable.dart';

class WishlistEntity extends Equatable {
  final String wishlistId;
  final String bookId;
  final String userId;
  final String author;
  final String title;
  final String coverImage;
  final double ratingAvg;

  const WishlistEntity({
    required this.wishlistId,
    required this.bookId,
    required this.userId,
    required this.author,
    required this.title,
    required this.coverImage,
    required this.ratingAvg,
  });
  @override
  List<Object?> get props => [
    wishlistId,
    bookId,
    userId,
    author,
    title,
    coverImage,
    ratingAvg,
  ];
}
