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

  const WishlistEntity.dummy({
    this.wishlistId = "asklfakfhk1",
    this.bookId = "1k2je1khr",
    this.userId = "1;2lj4l12h12r",
    this.author = "James Clear",
    this.title = "Atomic Habits",
    this.coverImage = "askfjkla",
    this.ratingAvg = 4.5,
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
