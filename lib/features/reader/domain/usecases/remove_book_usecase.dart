import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/reader/domain/repositories/local_book_repository.dart';

class RemoveBookUsecase extends BaseUsecase<void, int> {
  final LocalBookRepository localBookRepository;

  RemoveBookUsecase({required this.localBookRepository});
  @override
  Future<Either<Failure, void>> call(int bookId) async {
    final response = await localBookRepository.removeBook(bookId);
    return response;
  }
}
