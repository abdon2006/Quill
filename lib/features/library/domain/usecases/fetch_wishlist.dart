import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/library/domain/entities/wishlist_entity.dart';
import 'package:quill/features/library/domain/repositories/library_repository.dart';

class FetchWishlistUsecase extends BaseUsecase<List<WishlistEntity>, NoParams> {
  final LibraryRepository libraryRepository;

  FetchWishlistUsecase({required this.libraryRepository});
  @override
  Future<Either<Failure, List<WishlistEntity>>> call(NoParams params) async {
    final response = await libraryRepository.fetchWishlist(params);
    return response;
  }
}
