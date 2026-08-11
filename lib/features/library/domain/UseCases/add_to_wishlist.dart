  import 'package:dartz/dartz.dart';
  import 'package:quill/core/errors/failures.dart';
  import 'package:quill/core/usecases/base_usecase.dart';
  import 'package:quill/features/library/domain/Repositories/library_repository.dart';

  class AddToWishlistUsecase extends BaseUsecase<void, String> {
    final LibraryRepository libraryRepository;

    AddToWishlistUsecase({required this.libraryRepository});
    @override
    Future<Either<Failure, void>> call(String bookId) async {
      final response = await libraryRepository.addToWishlist(bookId);
      return response ;
    }
  }
