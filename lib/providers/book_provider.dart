import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/saved_book_model.dart';
import '../repositories/book_repository.dart';
import '../repositories/book_supabase_repository.dart';

class BookProvider with ChangeNotifier {
  final BookRepository _apiRepository;
  final BookSupabaseRepository _supabaseRepository = BookSupabaseRepository();

  BookProvider(this._apiRepository);

  // --- API Books State ---
  List<Book> _books = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _currentQuery = 'flutter';

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;

  // READ (API): Mengambil data buku dari Open Library API
  Future<void> fetchBooks([String query = 'flutter']) async {
    _isLoading = true;
    _errorMessage = '';
    _currentQuery = query.trim().isEmpty ? 'flutter' : query.trim();
    notifyListeners();

    try {
      _books = await _apiRepository.getBooks(_currentQuery);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Saved Books (Supabase Database CRUD State) ---
  List<SavedBook> _savedBooks = [];
  bool _isSavedLoading = false;
  String _savedErrorMessage = '';

  List<SavedBook> get savedBooks => _savedBooks;
  bool get isSavedLoading => _isSavedLoading;
  String get savedErrorMessage => _savedErrorMessage;

  // READ (Database): Mengambil catatan buku dari Supabase
  Future<void> fetchSavedBooks() async {
    _isSavedLoading = true;
    _savedErrorMessage = '';
    notifyListeners();

    try {
      _savedBooks = await _supabaseRepository.getSavedBooks();
    } catch (e) {
      _savedErrorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint("Error fetching saved books: $e");
    } finally {
      _isSavedLoading = false;
      notifyListeners();
    }
  }

  // CREATE (Database): Menambahkan catatan buku baru ke Supabase
  Future<void> saveBook({
    required String bookId,
    required String bookTitle,
    required String note,
    required double rating,
  }) async {
    await _supabaseRepository.addBook(
      bookId: bookId,
      bookTitle: bookTitle,
      note: note,
      rating: rating,
    );
    await fetchSavedBooks();
  }

  // UPDATE (Database): Mengedit catatan & rating pada Supabase
  Future<void> updateBook({
    required int id,
    required String note,
    required double rating,
  }) async {
    await _supabaseRepository.updateBook(
      id: id,
      note: note,
      rating: rating,
    );
    await fetchSavedBooks();
  }

  // DELETE (Database): Menghapus catatan dari Supabase
  Future<void> removeBook(dynamic id) async {
    final intId = id is int ? id : int.tryParse(id.toString()) ?? 0;
    await _supabaseRepository.deleteBook(intId);
    await fetchSavedBooks();
  }
}
