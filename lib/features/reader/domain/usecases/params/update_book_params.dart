class UpdateBookParams {
  final int bookId;
  final String title;
  final String author;
  final int currentPage;

  UpdateBookParams({
    required this.bookId,
    required this.title,
    required this.author,
    required this.currentPage,
  });
}
