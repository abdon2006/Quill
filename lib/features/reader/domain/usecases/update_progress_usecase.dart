import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/reader/domain/repositories/local_book_repository.dart';

class UpdateProgressUsecase {
  final LocalBookRepository localBookRepository;

  UpdateProgressUsecase({required this.localBookRepository});
  Future<Either<Failure, void>> call(int bookId, int newPage) async {
    final response = await localBookRepository.updateProgress(bookId, newPage);
    return response;
  }
}
