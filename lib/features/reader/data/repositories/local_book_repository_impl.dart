import 'dart:io';
import 'package:epubx/epubx.dart';
import 'package:html/parser.dart' as html_parser;
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
      
      final dir = await getApplicationDocumentsDirectory();

      
      final fileName = params.coverImagePath.split('/').last;

      
      final savedPath = '${dir.path}/$fileName';
      if (params.isCoverImageChange) {
        
        await File(params.coverImagePath).copy(savedPath);
      }

      
      final coverPath = params.isCoverImageChange
          ? savedPath
          : params.coverImagePath;

      final newParams = UpdateBookParams(
        bookId: params.bookId,
        title: params.title,
        author: params.author,
        progress: params.progress,
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
  book.language = 'en';
  book.categories = [];
  book.coverImagePath = null;
  book.progress = 0;
  book.totalPages = 0;
  book.importedAt = DateTime.now();
  return book;
}

Future<List<String>> _extractParagraphs(String path) async {
  if (path.endsWith('.pdf')) {
    final bytes = await File(path).readAsBytes();
    final doc = PdfDocument(inputBytes: bytes);
    final extractor = PdfTextExtractor(doc);

    final List<String> pages = [];

    
    for (int i = 0; i < doc.pages.count; i++) {
      final raw = extractor
          .extractText(startPageIndex: i, endPageIndex: i)
          .trim();
      final text = _cleanPageText(raw);
      

      if (_isUsefulPage(text)) pages.add(text);
    }
    

    doc.dispose();
    return pages;
  } else {
    final epubFile = File(path);
    final contents = await epubFile.readAsBytes();
    EpubBookRef epub = await EpubReader.openBook(contents.toList());
    Map<String, EpubTextContentFile> cont =
        await EpubReader.readTextContentFiles(epub.Content!.Html!);
    List<String> htmlList = [];
    for (var i in cont.values) {
      
      
      htmlList.add(i.Content!);
    }
    final doc = html_parser.parse(htmlList.join());
    final paragraphs =
        doc.body?.text
            .split(RegExp(r'\n+'))
            .map((paragraph) => paragraph.trim())
            .where(
              (paragraph) =>
                  paragraph.isNotEmpty &&
                  _isUsefulPage(paragraph, isEpub: true),
            )
            .toList() ??
        <String>[];
    
    return paragraphs;
  }
}

String _cleanPageText(String text) {
  
  final lines = text.split('\n');
  final buffer = StringBuffer();

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) {
      buffer.write('\n');
      continue;
    }
    
    if (line.length <= 3 && i < lines.length - 1) {
      buffer.write(line);
    } else {
      buffer.write('$line ');
    }
  }

  return buffer
      .toString()
      .replaceAll(RegExp(r'[əˈä·]'), '') 
      .replaceAll(RegExp(r'\s{2,}'), ' ') 
      .trim();
}

bool _isUsefulPage(String text, {bool isEpub = false}) {
  final words = text.split(' ').where((w) => w.isNotEmpty).toList();
  if (words.length < (isEpub ? 5 : 20)) return false;
  if (text.contains('http') || text.contains('www.')) return false;
  if (text.contains('ISBN')) return false;
  return true;
}
