import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'add_book_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  late Future<List<Book>> futureBooks;

  @override
  void initState() {
    super.initState();
    futureBooks = ApiService.getBooks();
  }

  void _refreshBooks() {
    setState(() {
      futureBooks = ApiService.getBooks();
    });
  }

  Future<bool?> _confirmDeleteBook(int id, String name) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Удалить книгу'),
        content: Text('Вы уверены, что хотите удалить книгу "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    try {
      await ApiService.deleteBook(id);
      _refreshBooks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Книга "$name" удалена')),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при удалении: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
  return false;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookScreen()),
          );
          if (result == true) {
            _refreshBooks();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Book>>(
        future: futureBooks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Book book = snapshot.data![index];
                return Dismissible(
                  key: Key('book_${book.id}'),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await _confirmDeleteBook(book.id!, book.name ?? '');
                  },
                  child: ListTile(
                    title: Text(book.name ?? 'No name'),
                    subtitle: Text('ID: ${book.id ?? 'N/A'}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteBook(book.id!, book.name ?? ''),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}