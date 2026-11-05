import 'package:flutter/foundation.dart';
import '../models/book_model.dart';
import '../repositories/book_repository.dart';

class BookProvider with ChangeNotifier {
  final BookRepository repository;
  BookProvider(this.repository);

  List<Book> _books = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchBooks() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _books = await repository.getBooks();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}