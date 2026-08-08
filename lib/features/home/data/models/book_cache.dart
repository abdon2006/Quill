import 'package:isar/isar.dart';
part 'book_cache.g.dart';
@collection
class BookCache {
  Id isarId = Isar.autoIncrement;
  late String id;
  late String title;
  late String author;
  late String coverImage;
  late String description;
  late String language;
  late int totalChunks;
  late double ratingAverage;
  late int ratingCount;
  late bool isPublic;
  late List<String> categories;
  late String aboutBook;
  late String forWho;
  late DateTime cachedAt;
}
