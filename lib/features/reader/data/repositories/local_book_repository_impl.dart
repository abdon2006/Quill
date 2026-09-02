import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/reader/data/datasources/local_book_data_source.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/domain/repositories/local_book_repository.dart';
import 'package:quill/features/reader/domain/usecases/params/update_book_params.dart';
import 'package:quill/features/reader/domain/usecases/params/upload_book_params.dart';

class LocalBookRepositoryImpl implements LocalBookRepository {
  final LocalBookDataSource bookLocalDataSource;

  LocalBookRepositoryImpl({required this.bookLocalDataSource});
  @override
  Future<Either<Failure, LocalBook>> fetchBook(int bookId) async {
    try {
      final response = await bookLocalDataSource.fetchBook(bookId);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBook(int bookId) async {
    try {
      final response = await bookLocalDataSource.removeBook(bookId);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBook(UpdateBookParams params) async {
    try {
      /// هنا انا باخد المسار الامن في التطبيق عشان احفظ فيه كل الملفات بشكل دائم وفي مكان امن
      final dir = await getApplicationDocumentsDirectory();

      /// باخد اسم الملف من المسار الطويل اللي جبته من
      final fileName = params.coverImagePath.split('/').last;

      /// ببني المسار الجديد الامن
      final savedPath = '${dir.path}/$fileName';
      if (params.isCoverImageChange) {
        /// لو الصورة اتغيرت فعلا بنسخ الملف نفسه اللي هي الصورة من المسار المؤقت اللي هي فيه للمسار الامن اللي انا جبته
        await File(params.coverImagePath).copy(savedPath);
      }

      /// لو الصورة اتغيرت الستخدم المسار الجديد الامن لو متغيرتش خلاص استخدم المسار بتاعها القديم
      final coverPath = params.isCoverImageChange
          ? savedPath
          : params.coverImagePath;

      final newParams = UpdateBookParams(
        bookId: params.bookId,
        title: params.title,
        author: params.author,
        currentPage: params.currentPage,
        coverImagePath: coverPath,
        isCoverImageChange: params.isCoverImageChange,
      );

      final response = await bookLocalDataSource.updateBook(newParams);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> uploadBook(UploadBookParams book) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = book.fileName;
      final savedPath = '${dir.path}/$fileName';
      final localFile = await File(book.filePath).copy(savedPath);
      final localBook = _initLocalBook(book, localFile.path);

      final List<String> paragraphs = await compute(
        _extractParagraphs,
        savedPath,
      );
      print(
        '----------- num of Paragraphs : ${paragraphs.length} -------------',
      );
      localBook.paragraphs = paragraphs;
      localBook.totalPages = paragraphs.length;
      final response = await bookLocalDataSource.uploadBook(localBook);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocalBook>>> fetchLocalBooks() async {
    try {
      final response = await bookLocalDataSource.fetchLocalBooks();
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }
}

LocalBook _initLocalBook(UploadBookParams params, String newPath) {
  final book = LocalBook();
  book.title = params.fileName.replaceAll('.pdf', '').replaceAll('.epub', '');
  book.filePath = newPath;
  book.fileType = params.fileExtension;
  book.author = 'Unknown Author';
  book.language = 'Unknown';
  book.categories = [];
  book.coverImagePath = null;
  book.currentPage = 0;
  book.totalPages = 0;
  book.importedAt = DateTime.now();
  return book;
}

Future<List<String>> _extractParagraphs(String path) async {
  final bytes = await File(path).readAsBytes();
  final doc = PdfDocument(inputBytes: bytes);
  final extractor = PdfTextExtractor(doc);

  final List<String> pages = [];

  print('----------- num of pages : ${doc.pages.count} -------------');
  for (int i = 0; i < doc.pages.count; i++) {
    final raw = extractor
        .extractText(startPageIndex: i, endPageIndex: i)
        .trim();
    final text = _cleanPageText(raw);
    print('Page $i cleaned: ${text.substring(0, text.length.clamp(0, 100))}');

    if (_isUsefulPage(text)) pages.add(text);
  }
  print('----------------- Pages : $pages ---------------');

  doc.dispose();
  return pages;
}

String _cleanPageText(String text) {
  // بنوحد السطور المتقطعة - لو السطر أقل من 3 حروف بنلحقه بالسطر اللي بعده
  final lines = text.split('\n');
  final buffer = StringBuffer();

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) {
      buffer.write('\n');
      continue;
    }
    // سطر قصير جداً = جزء من كلمة متقطعة
    if (line.length <= 3 && i < lines.length - 1) {
      buffer.write(line);
    } else {
      buffer.write('$line ');
    }
  }

  return buffer
      .toString()
      .replaceAll(RegExp(r'[əˈä·]'), '') // شيل رموز الـ pronunciation
      .replaceAll(RegExp(r'\s{2,}'), ' ') // شيل المسافات الزيادة
      .trim();
}

bool _isUsefulPage(String text) {
  final words = text.split(' ').where((w) => w.isNotEmpty).toList();
  if (words.length < 20) return false;
  if (text.contains('http') || text.contains('www.')) return false;
  if (text.contains('ISBN')) return false;
  return true;
}
