import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/domain/repositories/local_book_repository.dart';

class FetchLocalBooksUsecase {
  final LocalBookRepository localBookRepository;

  FetchLocalBooksUsecase({required this.localBookRepository});

  Future<Either<Failure, List<LocalBook>>> call() async {
    final response = await localBookRepository.fetchLocalBooks();
    return response;
  }
}
