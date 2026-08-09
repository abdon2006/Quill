import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/home/data/dataSources/book_local_data_source.dart';
import 'package:quill/features/home/data/dataSources/book_remote_datasource.dart';
import 'package:quill/features/home/data/models/book_cache.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final BookLocalDataSource bookLocalDataSource;
  final BookRemoteDatasource remoteDatasource;

  BookRepositoryImpl({
    required this.remoteDatasource,
    required this.bookLocalDataSource,
  });
  @override
  Future<Either<Failure, List<BookEntity>>> fetchBooks() async {
    try {
      final isCached = await bookLocalDataSource.isCacheValid();
      if (isCached) {
        print('Loaded From Cached ..........');
        final localBooks = await bookLocalDataSource.readBooks();
        return Right(BookMapper.mapBooksToBookEntity(localBooks));
      } else {
        print('calling the server ..........');
        final response = await remoteDatasource.fetchBooks();
        final cachedBooks = BookMapper.mapBooksToBookCache(response);
        await bookLocalDataSource.cacheBook(cachedBooks);
        return Right(response);
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isCacheValid() async {
    return await bookLocalDataSource.isCacheValid();
  }

  @override
  Future<Either<Failure, List<BookEntity>>> refreshBooks() async {
    try {
      print('Refreshing the server ..........');
      final response = await remoteDatasource.fetchBooks();
      final cachedBooks = BookMapper.mapBooksToBookCache(response);
      await bookLocalDataSource.cacheBook(cachedBooks);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class BookMapper {
  static BookEntity mapBookToBookEntity(BookCache book) {
    return BookEntity(
      id: book.id,
      title: book.title,
      author: book.author,
      coverImage: book.coverImage,
      description: book.description,
      language: book.language,
      totalChunks: book.totalChunks,
      ratingAverage: book.ratingAverage,
      ratingCount: book.ratingCount,
      isPublic: book.isPublic,
      categories: book.categories,
      aboutBook: book.aboutBook,
      forWho: book.forWho,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
    );
  }

  static BookCache mapBookToBookCache(BookEntity book) {
    final cache = BookCache();
    cache.id = book.id;
    cache.title = book.title;
    cache.author = book.author;
    cache.coverImage = book.coverImage;
    cache.description = book.description;
    cache.language = book.language;
    cache.totalChunks = book.totalChunks;
    cache.ratingAverage = book.ratingAverage;
    cache.ratingCount = book.ratingCount;
    cache.isPublic = book.isPublic;
    cache.categories = book.categories;
    cache.aboutBook = book.aboutBook;
    cache.forWho = book.forWho;
    cache.cachedAt = DateTime.now();
    cache.createdAt = book.createdAt;
    cache.updatedAt = book.updatedAt;
    return cache;
  }

  static List<BookEntity> mapBooksToBookEntity(List<BookCache> books) {
    return books.map((book) {
      return mapBookToBookEntity(book);
    }).toList();
  }

  static List<BookCache> mapBooksToBookCache(List<BookEntity> books) {
    return books.map((book) {
      return mapBookToBookCache(book);
    }).toList();
  }
}
