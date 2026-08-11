import 'package:quill/core/network/network_service.dart';
import 'package:quill/features/home/data/dataSources/book_remote_datasource.dart';
import 'package:quill/features/home/data/models/book_model.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';

class BookRemoteDataSourceImpl implements BookRemoteDatasource {
  final NetworkService networkService;

  BookRemoteDataSourceImpl({required this.networkService});
  @override
  Future<List<BookEntity>> fetchBooks() async {
    final response = await networkService.dioGet('/books', {});
    final List data = response.data['data']['books'];
    return data.map((json) => BookModel.fromJson(json)).toList();
  }

  @override
  Future<BookEntity> getBookById(String bookId) async {
    final response = await networkService.dioGet('/books/$bookId', {});
    return BookModel.fromJson(response.data['data']['book']);
  }
}
