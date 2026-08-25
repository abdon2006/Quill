import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/reader/domain/repositories/local_book_repository.dart';
import 'package:quill/features/reader/domain/usecases/params/upload_book_params.dart';

class UploadBookUsecase extends BaseUsecase<void, UploadBookParams> {
  final LocalBookRepository localBookRepository;

  UploadBookUsecase({required this.localBookRepository});
  @override
  Future<Either<Failure, void>> call(UploadBookParams book) async {
    final response = await localBookRepository.uploadBook(book);
    return response;
  }
}
