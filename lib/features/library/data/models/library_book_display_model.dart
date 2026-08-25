import 'package:quill/features/library/domain/entities/wishlist_entity.dart';
import 'package:quill/features/reader/data/models/local_book.dart';

enum BookSource { local, server }

class LibraryBookDisplayModel {
  final String title;
  final String author;
  String? coverImage;
  String? bookId;
  final BookSource bookSource;
  int? pages;
  int? currentPage;

  LibraryBookDisplayModel({
    required this.title,
    required this.author,
    this.coverImage,
    this.bookId,
    required this.bookSource,
    this.pages,
    this.currentPage,
  });
  LibraryBookDisplayModel.dummy({
    this.title = 'Atomic Habits',
    this.author = 'James Clear',
    this.coverImage = '',
    this.bookId = '',
    this.bookSource = BookSource.local,
    this.pages = 0,
    this.currentPage = 0,
  });
}

class LibraryMapper {
  static List<LibraryBookDisplayModel> mapWishlistEntityToDisplayModel(
    List<WishlistEntity> books,
  ) {
    return books.map((book) {
      return LibraryBookDisplayModel(
        title: book.title,
        author: book.author,
        coverImage: book.coverImage,
        bookSource: BookSource.server,
        bookId: book.bookId,
      );
    }).toList();
  }

  static List<LibraryBookDisplayModel> mapLocalBookToDisplayModel(
    List<LocalBook> books,
  ) {
    return books.map((book) {
      return LibraryBookDisplayModel(
        title: book.title,
        author: book.author,
        coverImage: book.coverImagePath ?? '',
        bookSource: BookSource.local,
        currentPage: book.currentPage,
        pages: book.totalPages,
      );
    }).toList();
  }
}
