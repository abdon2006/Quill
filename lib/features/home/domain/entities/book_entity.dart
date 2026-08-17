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
  final DateTime createdAt;
  final DateTime updatedAt;
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
    required this.createdAt,
    required this.updatedAt,
  });
  factory BookEntity.dummy() => BookEntity(
    id: '',
    title: 'Atomic Habits',
    author: 'James Clear',
    coverImage: '',
    description: '',
    language: 'en',
    totalChunks: 100,
    ratingAverage: 4.5,
    ratingCount: 20,
    isPublic: true,
    categories: [],
    aboutBook: '',
    forWho: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
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
    createdAt,
    updatedAt,
  ];
}
