import 'package:quill/features/home/domain/entities/book_entity.dart';

class CategoryParams {
  final List<BookEntity> books;
  final String category;

  CategoryParams({required this.books, required this.category});
}
