import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/domain/repositories/book_repository.dart';

class FetchBooksUsecase extends BaseUsecase<List<BookEntity>, NoParams> {
  final BookRepository bookRepository;
  FetchBooksUsecase({required this.bookRepository});
  @override
  Future<Either<Failure, List<BookEntity>>> call(NoParams params) async =>
      await bookRepository.fetchBooks();
}
