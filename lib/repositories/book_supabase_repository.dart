import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookSupabaseRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List> getSavedBooks() async {
    final response = await _supabase
        .from('saved_books')
        .select()
        .order('id', ascending: false);
    return List.from(response);
  }

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

  Future<void> deleteBook(int id) async {
    await _supabase.from('saved_books').delete().eq('id', id);
  }
}