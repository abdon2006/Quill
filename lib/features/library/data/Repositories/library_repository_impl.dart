import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/library/data/DateSources/library_remote_data_source.dart';
import 'package:quill/features/library/domain/Entities/wishlist_entity.dart';
import 'package:quill/features/library/domain/Repositories/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteDataSource libraryRemoteDataSource;
  LibraryRepositoryImpl({required this.libraryRemoteDataSource});

  @override
  Future<Either<Failure, void>> addToWishlist(String bookId) async {
    try {
      final response = await libraryRemoteDataSource.addToWishlist(bookId);
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
      final response = await libraryRemoteDataSource.fetchWishlist(params);
      return Right(response);
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
      return Right(response);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
