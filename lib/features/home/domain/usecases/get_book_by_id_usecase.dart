import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/domain/repositories/book_repository.dart';

class GetBookByIdUsecase extends BaseUsecase<BookEntity, String> {
  final BookRepository bookRepository;

  GetBookByIdUsecase({required this.bookRepository});
  @override
  Future<Either<Failure, BookEntity>> call(String bookId) async {
    final response = await bookRepository.getBookById(bookId);
    return response;
  }
}
