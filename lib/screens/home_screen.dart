import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_2415051051_juberta/providers/book_provider.dart';
import 'package:uts_2415051051_juberta/widgets/book_card.dart';
import 'package:uts_2415051051_juberta/widgets/custom_search_bar.dart';
import 'package:uts_2415051051_juberta/screens/book_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).fetchBooks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Provider.of<BookProvider>(context, listen: false).fetchBooks(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookFinder - Home'),
      ),
      body: Column(
        children: [
          // Reusable Custom Search Bar
          CustomSearchBar(
            controller: _searchController,
            onSearch: _onSearch,
            onClear: () {
              _searchController.clear();
              setState(() {});
              Provider.of<BookProvider>(context, listen: false).fetchBooks('flutter');
            },
            onChanged: (_) {
              setState(() {});
            },
          ),
          // Book Grid / Content
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, provider, child) {
                // 1. Loading State
                if (provider.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Memuat data buku...'),
                      ],
                    ),
                  );
                }

                // 2. Error State
                if (provider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text(
                            'Terjadi Kesalahan:\n${provider.errorMessage}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              provider.fetchBooks(provider.currentQuery);
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // 3. Empty State
                if (provider.books.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.menu_book, size: 64, color: Colors.grey),
                          const SizedBox(height: 12),
                          const Text(
                            'Tidak ada buku ditemukan.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _searchController.clear();
                              provider.fetchBooks('flutter');
                            },
                            child: const Text('Reset Pencarian'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // 4. Data State & Responsive Grid Layout (Compact: 2, Wide/Tablet: 4)
                return RefreshIndicator(
                  onRefresh: () => provider.fetchBooks(provider.currentQuery),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: provider.books.length,
                        itemBuilder: (context, index) {
                          final book = provider.books[index];
                          return BookCard(
                            book: book,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailScreen(book: book),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
