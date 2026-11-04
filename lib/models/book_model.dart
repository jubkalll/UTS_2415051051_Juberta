class Book {
  final String key;
  final String title;
  final String authorName;
  final String coverId;

  Book({
    required this.key,
    required this.title,
    required this.authorName,
    required this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    var authors = json['author_name'] as List?;
    String author = authors != null && authors.isNotEmpty ? authors.first : 'Unknown Author';
    
    var cover = json['cover_i'];
    String coverIdStr = cover != null ? cover.toString() : '';

    return Book(
      key: json['key'] ?? '',
      title: json['title'] ?? 'No Title',
      authorName: author,
      coverId: coverIdStr,
    );
  }

  String get coverUrl => coverId.isNotEmpty 
      ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg' 
      : 'https://via.placeholder.com/150';
}