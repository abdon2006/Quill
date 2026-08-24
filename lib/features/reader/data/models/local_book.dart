import 'package:isar/isar.dart';
part 'local_book.g.dart';

@collection
class LocalBook {
  Id isarId = Isar.autoIncrement;
  late String title;
  late String author;
  late String language;
  late List<String> categories;
  late String filePath;
  late String? coverImagePath;
  late int totalPages;
  late int currentPage;
  late String fileType;
  late DateTime importedAt;
}
