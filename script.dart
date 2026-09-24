import 'dart:io';
import 'package:dio/dio.dart';

final List<Map<String, dynamic>> booksToUpload = [
  {
    "title": "The Collected Poems of Emily Dickinson",
    "author": "Emily Dickinson",
    "description":
        "An extensive collection of lyrical, poignant, and unconventional poems exploring themes of death, immortality, and nature.",
    "brief": "Masterpieces of 19th-century American lyrical poetry.",
    "forWho": "Classic literature and poetry connoisseurs.",
    "language": "en",
    "categories": '["Poetry"]',
  },
  // {
  //   "title": "The 48 Laws of Power",
  //   "author": "Robert Greene",
  //   "description":
  //       "A pragmatic distillation of 3000 years of history on how to acquire, defend, and master power dynamics.",
  //   "brief": "Mastering strategy, influence, and social power dynamics.",
  //   "forWho": "Strategists, leaders, and history enthusiasts.",
  //   "language": "en",
  //   "categories": '["Self-Improvement", "Philosophy"]',
  // },
  // {
  //   "title": "Ariel",
  //   "author": "Sylvia Plath",
  //   "description":
  //       "Plath's famous and intense collection of poetry reflecting inner turmoil, raw emotion, and striking imagery.",
  //   "brief": "Powerful confessional poetry by Sylvia Plath.",
  //   "forWho": "Lovers of deep, confessional, and emotional poetry.",
  //   "language": "en",
  //   "categories": '["Poetry"]',
  // },
  {
    "title": "The Collected Poems of Dylan Thomas",
    "author": "Dylan Thomas",
    "description":
        "Passionate, lyrical, and rich musical verse by the famous Welsh poet, including Do not go gentle into that good night.",
    "brief": "Lyrical and emotionally charged classic poetry.",
    "forWho": "Lovers of passionate and musical verse.",
    "language": "en",
    "categories": '["Poetry"]',
  },
];

void main() async {
  final directoryPath =
      '/media/abdallah/New Data/my projects/Flutter/Temps/Quill/books_to_upload';
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
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhYjFkZDg5MWJjYTVjZGVkNzg4NTNjMSIsImlhdCI6MTc5MDA3NTI4NiwiZXhwIjoxNzkwNjgwMDg2fQ.Ecb_X9kVJiYyinzfAqV-G5f6gBn4NFk8k2YBWldWMKA";

  print(
    '🚀 Starting smart auto-upload process for ${booksToUpload.length} books...\n',
  );

  for (int i = 0; i < booksToUpload.length; i++) {
    final book = booksToUpload[i];
    final String title = book["title"];

    // تنظيف اسم الكتاب للبحث عنه بسلاسة داخل أسماء الملفات العشوائية
    final String searchQuery = title.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );

    File? pdfFile;
    File? coverFile;

    // البحث الذكي داخل الفولدر عن الملفات المطابقة
    for (var entity in files) {
      if (entity is File) {
        String fileNameLower = entity.path.toLowerCase();
        String cleanFileName = fileNameLower.replaceAll(
          RegExp(r'[^a-z0-9]'),
          '',
        );

        // لو اسم الملف بيحتوي على أجزاء رئيسية من اسم الكتاب
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
