import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/reader.dart';
import '../models/book_rental.dart';
import '../services/api_service.dart';

class AddRentalScreen extends StatefulWidget {
  const AddRentalScreen({super.key});

  @override
  State<AddRentalScreen> createState() => _AddRentalScreenState();
}

class _AddRentalScreenState extends State<AddRentalScreen> {
  late Future<List<Book>> futureBooks;
  late Future<List<Reader>> futureReaders;
  Book? _selectedBook;
  Reader? _selectedReader;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    futureBooks = ApiService.getBooks();
    futureReaders = ApiService.getReaders();
  }

  Future<void> _addRental() async {
    if (_selectedBook == null || _selectedReader == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, выберите книгу и читателя'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.addBookRental(BookRental(
        bookId: _selectedBook!.id!,
        readerId: _selectedReader!.id!,
      ));
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при добавлении выдачи: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выдать книгу'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Выбор книги
            FutureBuilder<List<Book>>(
              future: futureBooks,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButtonFormField<Book>(
                    value: _selectedBook,
                    decoration: const InputDecoration(
                      labelText: 'Выберите книгу',
                      border: OutlineInputBorder(),
                    ),
                    items: snapshot.data!.map((Book book) {
                      return DropdownMenuItem<Book>(
                        value: book,
                        child: Text(book.name ?? 'Без названия'),
                      );
                    }).toList(),
                    onChanged: _isLoading
                        ? null
                        : (Book? newValue) {
                            setState(() {
                              _selectedBook = newValue;
                            });
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Пожалуйста, выберите книгу';
                      }
                      return null;
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Ошибка загрузки книг: ${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 20),
            // Выбор читателя
            FutureBuilder<List<Reader>>(
              future: futureReaders,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButtonFormField<Reader>(
                    value: _selectedReader,
                    decoration: const InputDecoration(
                      labelText: 'Выберите читателя',
                      border: OutlineInputBorder(),
                    ),
                    items: snapshot.data!.map((Reader reader) {
                      return DropdownMenuItem<Reader>(
                        value: reader,
                        child: Text(
                            '${reader.name ?? ''} ${reader.lastname ?? ''}'.trim()),
                      );
                    }).toList(),
                    onChanged: _isLoading
                        ? null
                        : (Reader? newValue) {
                            setState(() {
                              _selectedReader = newValue;
                            });
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Пожалуйста, выберите читателя';
                      }
                      return null;
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Ошибка загрузки читателей: ${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 30),
            // Кнопка добавления
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _addRental,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Выдать книгу',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
            const SizedBox(height: 10),
            _isLoading
                ? Container()
                : TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
          ],
        ),
      ),
    );
  }
}