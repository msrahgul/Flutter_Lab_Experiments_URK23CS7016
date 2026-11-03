import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

const List<Map<String, dynamic>> _localBooks = [
  {'title': 'The Hobbit', 'author': 'J. R. R. Tolkien', 'copies': 4},
  {'title': 'Atomic Habits', 'author': 'James Clear', 'copies': 2},
  {'title': 'The Alchemist', 'author': 'Paulo Coelho', 'copies': 0},
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {
    // The app remains usable with its local catalog when Firebase is not set up.
  }
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library Book Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const BookSearchPage(),
    );
  }
}

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({super.key});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final _titleController = TextEditingController();
  bool _loading = false;
  bool _searched = false;
  Map<String, dynamic>? _book;
  List<Map<String, dynamic>> _books = _localBooks;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('books').get();
      if (snapshot.docs.isNotEmpty && mounted) {
        setState(() => _books = snapshot.docs.map((doc) => doc.data()).toList());
      }
    } catch (_) {
      // Keep the local catalog visible.
    }
  }

  Future<void> _searchBook() async {
    final query = _titleController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    setState(() {
      _loading = true;
      _searched = true;
      _book = null;
    });

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('books').get();
      for (final doc in snapshot.docs) {
        final data = doc.data();
        if ((data['title'] ?? '').toString().toLowerCase() == query) {
          _book = data;
          break;
        }
      }
    } catch (e) {
      // Fall back to the local catalog when Firestore is unavailable.
    } finally {
      _book ??= _books.cast<Map<String, dynamic>?>().firstWhere(
            (book) => book!['title'].toString().toLowerCase() == query,
            orElse: () => null,
          );
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildResult() {
    if (_loading) return const CircularProgressIndicator();
    if (!_searched) return const SizedBox.shrink();

    if (_book == null) {
      return const Text('Book not found',
          style: TextStyle(
              color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold));
    }

    final int copies = (_book!['copies'] as num?)?.toInt() ?? 0;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${_book!['title']}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Author: ${_book!['author']}'),
            const SizedBox(height: 6),
            Text('Copies Available: $copies'),
            if (copies == 0) ...[
              const SizedBox(height: 10),
              const Text('Not Available - All Copies Issued',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library Book Search')),
      body: Column(children: [
        Expanded(child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Enter Book Title',
                prefixIcon: Icon(Icons.menu_book),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchBook(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _searchBook,
                icon: const Icon(Icons.search),
                label: const Text('Search'),
              ),
            ),
            const SizedBox(height: 20),
            if (!_searched) ...[
              const Align(alignment: Alignment.centerLeft, child: Text('Available Books', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              Expanded(child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  final book = _books[index];
                  return Card(child: ListTile(
                    leading: const Icon(Icons.menu_book),
                    title: Text(book['title']?.toString() ?? ''),
                    subtitle: Text('${book['author'] ?? ''} · ${book['copies'] ?? 0} copies'),
                    onTap: () {
                      _titleController.text = book['title']?.toString() ?? '';
                      _searchBook();
                    },
                  ));
                },
              )),
            ] else _buildResult(),
          ],
        ),
      )),
        const Padding(padding: EdgeInsets.all(8), child: Text('Register No: URK23CS7016', textAlign: TextAlign.center)),
      ]),
    );
  }
}
