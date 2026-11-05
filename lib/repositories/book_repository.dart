import '../models/book_model.dart';
import '../services/api_service.dart';

class BookRepository {
  final ApiService apiService;
  BookRepository(this.apiService);

  Future<List<Book>> getBooks([String query = 'flutter']) async {
    return await apiService.fetchBooks(query);
  }
}
