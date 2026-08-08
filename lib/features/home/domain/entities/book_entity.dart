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
  final String aboutBook;
  final String forWho;
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
    required this.aboutBook,
    required this.forWho,
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
    aboutBook,
    forWho,
  ];
}
