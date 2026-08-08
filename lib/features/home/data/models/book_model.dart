import 'package:quill/features/home/domain/entities/book_entity.dart';

class BookModel extends BookEntity {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.coverImage,
    required super.description,
    required super.language,
    required super.totalChunks,
    required super.ratingAverage,
    required super.ratingCount,
    required super.isPublic,
    required super.categories,
    required super.aboutBook,
    required super.forWho,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['_id'] as String, // MongoDB بيبعت _id مش id
      title: json['title'] as String,
      author: json['author'] as String,
      coverImage: json['coverImage'] as String,
      description: json['description'] as String,
      language: json['language'] as String,
      totalChunks: json['totalChunks'] as int,
      ratingAverage: (json['ratingsAverage'] as num).toDouble(),
      ratingCount: json['ratingsCount'] as int,
      isPublic: json['isPublic'] as bool,
      categories: List<String>.from(json['categories'] ?? []),
      aboutBook: json['brief'],
      forWho: json['forWho'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'author': author,
      'coverImage': coverImage,
      'description': description,
      'language': language,
      'totalChunks': totalChunks,
      'ratingsAverage': ratingAverage,
      'ratingsCount': ratingCount,
      'isPublic': isPublic,
      'categories': categories,
      'brief': aboutBook,
      'forWho': forWho,
    };
  }
}
