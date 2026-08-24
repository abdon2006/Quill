import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/domain/repositories/local_book_repository.dart';

class UploadBookUsecase extends BaseUsecase<void, LocalBook> {
  final LocalBookRepository localBookRepository;

  UploadBookUsecase({required this.localBookRepository});
  @override
  Future<Either<Failure, void>> call(LocalBook book) async {
    final response = await localBookRepository.uploadBook(book);
    return response;
  }
}
