import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/saved_book_model.dart';

class BookSupabaseRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // READ: Mengambil seluruh buku/catatan tersimpan
  Future<List<SavedBook>> getSavedBooks() async {
    final response = await _supabase
        .from('saved_books')
        .select()
        .order('id', ascending: false);
    final list = List<Map<String, dynamic>>.from(response);
    return list.map((item) => SavedBook.fromJson(item)).toList();
  }

  // CREATE: Menyimpan buku dan catatan baru
  Future<void> addBook({
    required String bookId,
    required String bookTitle,
    required String note,
    required double rating,
  }) async {
    await _supabase.from('saved_books').insert({
      'book_id': bookId,
      'book_title': bookTitle,
      'note': note,
      'rating': rating,
    });
  }

  // UPDATE: Memperbarui catatan dan rating buku tersimpan
  Future<void> updateBook({
    required int id,
    required String note,
    required double rating,
  }) async {
    await _supabase.from('saved_books').update({
      'note': note,
      'rating': rating,
    }).eq('id', id);
  }

  // DELETE: Menghapus buku/catatan dari database
  Future<void> deleteBook(int id) async {
    await _supabase.from('saved_books').delete().eq('id', id);
  }
}
