import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/reader/domain/repositories/local_book_repository.dart';
import 'package:quill/features/reader/domain/usecases/params/update_book_params.dart';

class UpdateBookUsecase extends BaseUsecase<void , UpdateBookParams> {
  final LocalBookRepository localBookRepository;

  UpdateBookUsecase({required this.localBookRepository});
  @override
  Future<Either<Failure, void>> call(UpdateBookParams params) async {
    final response = await localBookRepository.updateBook(params);
    return response;
  }
}
