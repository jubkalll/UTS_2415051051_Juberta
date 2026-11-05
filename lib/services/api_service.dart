import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class ApiService {
  static const String baseUrl = 'https://openlibrary.org/search.json';

  Future<List<Book>> fetchBooks([String query = 'flutter']) async {
    try {
      final q = query.trim().isEmpty ? 'flutter' : query.trim();
      final response = await http.get(Uri.parse('$baseUrl?q=${Uri.encodeQueryComponent(q)}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List docs = data['docs'] ?? [];
        return docs.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data dari server (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}
