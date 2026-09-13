import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/library/data/datesources/library_local_data_source.dart';
import 'package:quill/features/library/data/datesources/library_remote_data_source.dart';
import 'package:quill/features/library/data/models/wishlist_cache.dart';
import 'package:quill/features/library/domain/entities/wishlist_entity.dart';
import 'package:quill/features/library/domain/repositories/library_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryLocalDataSource libraryLocalDataSource;
  final LibraryRemoteDataSource libraryRemoteDataSource;
  LibraryRepositoryImpl({
    required this.libraryRemoteDataSource,
    required this.libraryLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> addToWishlist(String bookId) async {
    try {
      final response = await libraryRemoteDataSource.addToWishlist(bookId);

      /// هنا مسحنا عشان بعد كده لما يفتح يلاقيها فاضية يكلم السيرفر
      await libraryLocalDataSource.cacheWishlist([]);
      return Right(response);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WishlistEntity>>> fetchWishlist(
    NoParams params,
  ) async {
    try {
      List<WishlistEntity> finalBooks = [];

      final cachedBooks = await libraryLocalDataSource.fetchWishlist();
      if (cachedBooks.isEmpty) {
        print('Loaded The Wishlist From The SERVER');

        final response = await libraryRemoteDataSource.fetchWishlist(params);

        final cachedFromTheServer = WishlistMapper.mapToWishlistCacheBooks(
          response,
        );
        await libraryLocalDataSource.cacheWishlist(cachedFromTheServer);
        finalBooks = response;
        // return Right(response);
      } else {
        print('Loaded The Wishlist From The CACHE');
        finalBooks = WishlistMapper.mapToWishlistEntityBooks(cachedBooks);
      }

      final prefs = await SharedPreferences.getInstance();
      final mergedBooks = finalBooks.map((book) {
        final savedProgress = prefs.getDouble(book.bookId) ?? 0.0;
        return WishlistEntity(
          wishlistId: book.wishlistId,
          bookId: book.bookId,
          userId: book.userId,
          author: book.author,
          title: book.title,
          coverImage: book.coverImage,
          ratingAvg: book.ratingAvg,
          progress: savedProgress.toInt(),
        );
      }).toList();
      return Right(mergedBooks);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(String bookId) async {
    try {
      final response = await libraryRemoteDataSource.removeFromWishlist(bookId);
      await libraryLocalDataSource.removeFromCache(bookId);
      return Right(response);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class WishlistMapper {
  static WishlistEntity mapWishlistCacheToWishlistEntity(WishlistCache book) {
    return WishlistEntity(
      wishlistId: book.wishlistId,
      bookId: book.bookId,
      userId: book.userId,
      author: book.author,
      title: book.title,
      coverImage: book.coverImage,
      ratingAvg: book.ratingAvg,
      progress: book.progress,
    );
  }

  static WishlistCache mapWishlistEntityToWishlistCache(WishlistEntity book) {
    final cache = WishlistCache();
    cache.wishlistId = book.wishlistId;
    cache.bookId = book.bookId;
    cache.userId = book.userId;
    cache.author = book.author;
    cache.title = book.title;
    cache.coverImage = book.coverImage;
    cache.ratingAvg = book.ratingAvg;
    cache.progress = book.progress;
    return cache;
  }

  static List<WishlistCache> mapToWishlistCacheBooks(
    List<WishlistEntity> books,
  ) {
    return books.map((book) {
      return WishlistMapper.mapWishlistEntityToWishlistCache(book);
    }).toList();
  }

  static List<WishlistEntity> mapToWishlistEntityBooks(
    List<WishlistCache> books,
  ) {
    return books.map((book) {
      return WishlistMapper.mapWishlistCacheToWishlistEntity(book);
    }).toList();
  }
}
