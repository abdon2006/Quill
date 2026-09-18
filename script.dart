import 'package:dio/dio.dart';

final List<Map<String, dynamic>> booksToUpload = [
  {
    "title": "The Power of Now",
    "author": "Eckhart Tolle",
    "description":
        "A guide to spiritual enlightenment that emphasizes the importance of living in the present moment to achieve happiness.",
    "brief": "A spiritual guide to living fully in the present.",
    "forWho": "People seeking mindfulness and inner peace.",
    "language": "en",
    "categories": '["Philosophy", "Self-Improvement"]',
    "coverPath":
        "/home/abdallah/Downloads/Quill/books_to_upload/The Power of Now.jpg",
    "pdfPath":
        "/home/abdallah/Downloads/Quill/books_to_upload/The Power Of Now - Eckhart Tolle.pdf",
  },
  {
    "title": "1984",
    "author": "George Orwell",
    "description":
        "A dystopian social science fiction novel that explores the dangers of totalitarianism, mass surveillance, and repressive regimentation.",
    "brief": "A chilling dystopian warning about totalitarianism.",
    "forWho": "Fans of dystopian fiction and political philosophy.",
    "language": "en",
    "categories": '["Fiction", "Science Fiction"]',
    "coverPath": "/home/abdallah/Downloads/Quill/books_to_upload/1984.jpg",
    "pdfPath": "/home/abdallah/Downloads/Quill/books_to_upload/1984.pdf",
  },
  {
    "title": "Rich Dad Poor Dad",
    "author": "Robert T. Kiyosaki",
    "description":
        "A book that advocates the importance of financial literacy, financial independence, and building wealth through investing.",
    "brief": "Lessons on wealth, assets, and financial independence.",
    "forWho": "Aspiring entrepreneurs and those seeking financial literacy.",
    "language": "en",
    "categories": '["Self-Improvement", "Finance"]',
    "coverPath":
        "/home/abdallah/Downloads/Quill/books_to_upload/Rich Dad Poor Dad.jpg",
    "pdfPath":
        "/home/abdallah/Downloads/Quill/books_to_upload/Rich Dad Poor Dad.pdf",
  },
  {
    "title": "Dune",
    "author": "Frank Herbert",
    "description":
        "A masterpiece of science fiction that tells the complex story of a young nobleman on a dangerous desert planet.",
    "brief": "An epic sci-fi adventure on the desert planet Arrakis.",
    "forWho": "Sci-fi fans and lovers of complex world-building.",
    "language": "en",
    "categories": '["Fiction", "Science Fiction"]',
    "coverPath": "/home/abdallah/Downloads/Quill/books_to_upload/Dune.jpg",
    "pdfPath": "/home/abdallah/Downloads/Quill/books_to_upload/Dune.pdf",
  },
  {
    "title": "Clean Code",
    "author": "Robert C. Martin",
    "description":
        "A handbook of agile software craftsmanship, teaching developers how to write readable, maintainable, and efficient code.",
    "brief": "A manual for writing readable and maintainable software.",
    "forWho": "Software engineers and developers.",
    "language": "en",
    "categories": '["Science", "Programming"]',
    "coverPath":
        "/home/abdallah/Downloads/Quill/books_to_upload/Clean Code.webp",
    "pdfPath": "/home/abdallah/Downloads/Quill/books_to_upload/clean-code.pdf",
  },
  {
    "title": "Fahrenheit 451",
    "author": "Ray Bradbury",
    "description":
        "A dystopian novel about a future American society where books are outlawed and 'firemen' burn any that are found.",
    "brief": "A dystopian tale where books are banned and burned.",
    "forWho": "Sci-fi readers and free speech advocates.",
    "language": "en",
    "categories": '["Fiction", "Science Fiction"]',
    "coverPath":
        "/home/abdallah/Downloads/Quill/books_to_upload/Fahrenheit 451.jpg",
    "pdfPath":
        "/home/abdallah/Downloads/Quill/books_to_upload/Fahrenheit 451.pdf",
  },
];

Future<void> uploadAllBooks() async {
  final dio = Dio();
  final String url = "http://192.168.1.5:5000/api/v1/books";
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhYTY3ZGM4ODQ3MmMyNWViZTEzODEyYiIsImlhdCI6MTc4OTczMjMxMCwiZXhwIjoxNzkwMzM3MTEwfQ.hjvp1UpEoLhYV2WkXvm41e_dZEQ94SOiEwzH9dXGL8Y";

  print("Starting bulk upload for ${booksToUpload.length} books...");

  for (int i = 0; i < booksToUpload.length; i++) {
    final book = booksToUpload[i];
    print("Uploading book ${i + 1}/${booksToUpload.length}: ${book['title']}");

    try {
      FormData formData = FormData();

      // ضفنا الحقلين الجداد هنا للـ FormData
      formData.fields.addAll([
        MapEntry("title", book["title"].toString()),
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
            book["coverPath"],
            filename: book["coverPath"].split('/').last,
          ),
        ),
        MapEntry(
          "pdf",
          await MultipartFile.fromFile(
            book["pdfPath"],
            filename: book["pdfPath"].split('/').last,
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Success: ${book['title']} uploaded!");
      } else {
        print(
          "⚠️ Warning: ${book['title']} uploaded with status ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      print("❌ Failed to upload: ${book['title']}");

      if (e.response != null) {
        print("➡️ Status Code: ${e.response?.statusCode}");
        print("➡️ Server Response: ${e.response?.data}");
      } else {
        print("➡️ Dio Error: ${e.message}");
      }
    } catch (e) {
      print("❌ Unknown Error: $e");
    }

    await Future.delayed(const Duration(seconds: 1));
  }

  print("🎉 All done!");
}

void main() async {
  await uploadAllBooks();
}
