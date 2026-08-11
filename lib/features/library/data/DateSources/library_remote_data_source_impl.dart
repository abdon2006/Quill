import 'package:quill/core/network/network_service.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/library/data/DateSources/library_remote_data_source.dart';
import 'package:quill/features/library/data/Models/wishlist_model.dart';
import 'package:quill/features/library/domain/Entities/wishlist_entity.dart';

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  final NetworkService networkService;

  LibraryRemoteDataSourceImpl({required this.networkService});
  @override
  Future<void> addToWishlist(String bookId) async =>
      await networkService.dioPost('/wishlist/$bookId', {});

  @override
  Future<List<WishlistEntity>> fetchWishlist(NoParams params) async {
    final response = await networkService.dioGet('/wishlist/', {});
    final List data = response.data['data']['wishlist'];
    print(response.data);
    return data.map((book) => WishlistModel.fromJson(book)).toList();
  }

  @override
  Future<void> removeFromWishlist(String bookId) async =>
      await networkService.dioDelete('/wishlist/$bookId', {});
}
