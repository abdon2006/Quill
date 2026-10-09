// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dio/dio.dart';


// ... كمل باقي السكريبت عادي جداً
void main() async {
  final directoryPath = '/home/abdallah/Downloads';
  final dir = Directory(directoryPath);

  if (!dir.existsSync()) {
    print('❌ Error: Directory not found -> $directoryPath');
    return;
  }

  final files = dir.listSync();
  final dio = Dio();
  final String url =
      'https://quill-api-production-a70e.up.railway.app/api/v1/books';
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhYjFkZDg5MWJjYTVjZGVkNzg4NTNjMSIsImlhdCI6MTc5MTE4MDQ0NCwiZXhwIjoxNzkxNzg1MjQ0fQ.Uzw3xRPCX_QTDZLuULKE9t3vX_mmdxcVSiUU5tJG7OY";

  print(
    '🚀 Starting smart auto-upload process for ${booksToUpload.length} books...\n',
  );

  for (int i = 0; i < booksToUpload.length; i++) {
    final book = booksToUpload[i];
    final String title = book["title"];

    final String searchQuery = title.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );

    File? pdfFile;
    File? coverFile;

    for (var entity in files) {
      if (entity is File) {
        String fileNameLower = entity.path.toLowerCase();
        String cleanFileName = fileNameLower.replaceAll(
          RegExp(r'[^a-z0-9]'),
          '',
        );

        if (cleanFileName.contains(
          searchQuery.substring(
            0,
            (searchQuery.length > 10 ? 10 : searchQuery.length),
          ),
        )) {
          if (fileNameLower.endsWith('.pdf')) {
            pdfFile = entity;
          } else if (fileNameLower.endsWith('.jpg') ||
              fileNameLower.endsWith('.png') ||
              fileNameLower.endsWith('.webp')) {
            coverFile = entity;
          }
        }
      }
    }

    if (pdfFile == null || coverFile == null) {
      print(
        '⚠️ Skipped "$title": Could not find matching PDF or Cover automatically.',
      );
      continue;
    }

    print('⏳ [${i + 1}] Uploading: "$title"...');
    print('   📄 PDF: ${pdfFile.path.split('/').last}');
    print('   🖼️ Cover: ${coverFile.path.split('/').last}');

    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry("title", title),
        MapEntry("author", book["author"].toString()),
        MapEntry("description", book["description"].toString()),
        MapEntry("brief", book["brief"].toString()),
        MapEntry("forWho", book["forWho"].toString()),
        MapEntry("language", book["language"].toString()),
        MapEntry("categories", book["categories"].toString()),
      ]);

      formData.files.addAll([
        MapEntry(
          "cover",
          await MultipartFile.fromFile(
            coverFile.path,
            filename: coverFile.path.split('/').last,
          ),
        ),
        MapEntry(
          "pdf",
          await MultipartFile.fromFile(
            pdfFile.path,
            filename: pdfFile.path.split('/').last,
          ),
        ),
      ]);

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      print('✅ Success! Uploaded: "$title" (Status: ${response.statusCode})\n');
    } catch (e) {
      print('❌ Error uploading "$title": $e\n');
    }

    await Future.delayed(const Duration(seconds: 1));
  }

  print('🎉 All files processing finished!');
}
