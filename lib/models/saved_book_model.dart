class SavedBook {
  final int id;
  final String bookId;
  final String bookTitle;
  final String note;
  final double rating;
  final String? createdAt;

  SavedBook({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.note,
    required this.rating,
    this.createdAt,
  });

  factory SavedBook.fromJson(Map<String, dynamic> json) {
    return SavedBook(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      bookId: json['book_id']?.toString() ?? '',
      bookTitle: json['book_title']?.toString() ?? 'Tanpa Judul',
      note: json['note']?.toString() ?? '',
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book_id': bookId,
      'book_title': bookTitle,
      'note': note,
      'rating': rating,
    };
  }

  SavedBook copyWith({
    int? id,
    String? bookId,
    String? bookTitle,
    String? note,
    double? rating,
    String? createdAt,
  }) {
    return SavedBook(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      note: note ?? this.note,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
