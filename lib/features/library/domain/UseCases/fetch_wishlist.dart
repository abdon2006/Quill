  import 'package:dartz/dartz.dart';
  import 'package:quill/core/errors/failures.dart';
  import 'package:quill/core/usecases/base_usecase.dart';
  import 'package:quill/features/home/domain/entities/book_entity.dart';
  import 'package:quill/features/library/domain/Repositories/library_repository.dart';

  class FetchWishlistUsecase extends BaseUsecase<List<BookEntity>, NoParams> {
    final LibraryRepository libraryRepository;

    FetchWishlistUsecase({required this.libraryRepository});
    @override
    Future<Either<Failure,  List<BookEntity>  >> call(NoParams params) async {
      final response = await libraryRepository.fetchWishlist(params);
      return response ;
    }
  }
