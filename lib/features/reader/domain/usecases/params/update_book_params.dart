class UpdateBookParams {
  final int bookId;
  final String title;
  final String author;
  final int currentPage;
  final String coverImagePath;
  final bool isCoverImageChange;

  UpdateBookParams({
    required this.bookId,
    required this.title,
    required this.author,
    required this.currentPage,
    required this.coverImagePath,
    required this.isCoverImageChange,
  });
}
