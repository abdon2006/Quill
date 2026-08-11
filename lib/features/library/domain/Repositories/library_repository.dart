import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/library/domain/Entities/wishlist_entity.dart';

abstract class LibraryRepository {
  Future<Either<Failure, void>> addToWishlist(String bookId);
  Future<Either<Failure, void>> removeFromWishlist(String bookId);
  Future<Either<Failure, List<WishlistEntity>>> fetchWishlist(NoParams params);
}
