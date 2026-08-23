import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/library/domain/repositories/library_repository.dart';

class RemoveFromWishlistUsecase extends BaseUsecase<void, String> {
  final LibraryRepository libraryRepository;

  RemoveFromWishlistUsecase({required this.libraryRepository});
  @override
  Future<Either<Failure, void>> call(String bookId) async {
    final response = await libraryRepository.removeFromWishlist(bookId);
    return response;
  }
}
