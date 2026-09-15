class UpdateBookParams {
  final int bookId;
  final String title;
  final String author;
  final int progress;
  final String coverImagePath;
  final bool isCoverImageChange;

  UpdateBookParams({
    required this.bookId,
    required this.title,
    required this.author,
    required this.progress,
    required this.coverImagePath,
    required this.isCoverImageChange,
  });
}
