import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String id;
  final String title;
  final String author;
  final String coverImage;
  final String description;
  final String language;
  final int totalChunks;
  final double ratingAverage;
  final int ratingCount;
  final bool isPublic;
  final List<String> categories;

  /// دي انا جت في دماغي اني اعملها بس للاسف كان بعد ما الباك اند خلص فمش مشكلة هتبقي تتعدل في الباك اند فهنسيبها كده لحد ما تتتضاف
  // final String aboutThisBook;
  // final String topics;
  // final String authorIntro;

  const BookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.description,
    required this.language,
    required this.totalChunks,
    required this.ratingAverage,
    required this.ratingCount,
    required this.isPublic,
    required this.categories,
    // required this.aboutThisBook,
    // required this.topics,
    // required this.authorIntro,
  });
  @override
  List<Object?> get props => [
    id,
    title,
    ratingAverage,
    author,
    ratingCount,
    description,
    isPublic,
    coverImage,
    language,
    totalChunks,
  ];
}
