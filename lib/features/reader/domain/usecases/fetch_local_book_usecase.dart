import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/domain/repositories/local_book_repository.dart';

class FetchLocalBookUsecase extends BaseUsecase<LocalBook, int> {
  final LocalBookRepository localBookRepository;

  FetchLocalBookUsecase({required this.localBookRepository});
  @override
  Future<Either<Failure, LocalBook>> call(int bookId) async {
    final response = await localBookRepository.fetchBook(bookId);
    return response;
  }
}
