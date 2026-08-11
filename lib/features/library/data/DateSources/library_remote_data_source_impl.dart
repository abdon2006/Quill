import 'package:quill/core/network/network_service.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/home/data/models/book_model.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/library/data/DateSources/library_remote_data_source.dart';

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  final NetworkService networkService;

  LibraryRemoteDataSourceImpl({required this.networkService});
  @override
  Future<void> addToWishlist(String bookId) async =>
      await networkService.dioPost('/wishlist/', {});

  @override
  Future<List<BookEntity>> fetchWishlist(NoParams params) async {
    final response = await networkService.dioGet('/wishlist/', {});
    final List data = response.data['wishlist'];
    return data.map((book) => BookModel.fromJson(book['bookId'])).toList();
  }

  @override
  Future<void> removeFromWishlist(String bookId) async =>
      await networkService.dioDelete('/wishlist/$bookId', {});
}
