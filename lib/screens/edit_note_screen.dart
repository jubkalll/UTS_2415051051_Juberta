import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_book_model.dart';
import '../providers/book_provider.dart';

class EditNoteScreen extends StatefulWidget {
  final SavedBook savedBook;

  const EditNoteScreen({super.key, required this.savedBook});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _noteController;
  late double _rating;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.savedBook.note);
    _rating = widget.savedBook.rating;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _updateNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await Provider.of<BookProvider>(context, listen: false).updateBook(
        id: widget.savedBook.id,
        note: _noteController.text.trim(),
        rating: _rating,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil diperbarui di database!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui catatan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan Buku'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.book, color: Colors.white),
                  ),
                  title: Text(
                    widget.savedBook.bookTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID Buku: ${widget.savedBook.bookId}'),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Edit Catatan Pribadi',
                  border: OutlineInputBorder(),
                  hintText: 'Perbarui kesan atau catatan tentang buku ini...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    'Rating: ${_rating.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Slider(
                value: _rating,
                min: 1.0,
                max: 5.0,
                divisions: 8,
                label: _rating.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16)),
                  onPressed: _isSaving ? null : _updateNote,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
