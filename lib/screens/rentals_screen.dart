import 'package:flutter/material.dart';
import '../models/book_rental.dart';
import '../services/api_service.dart';
import 'add_rental_screen.dart';

class RentalsScreen extends StatefulWidget {
  const RentalsScreen({super.key});

  @override
  State<RentalsScreen> createState() => _RentalsScreenState();
}

class _RentalsScreenState extends State<RentalsScreen> {
  late Future<List<BookRental>> futureBookRentals;

  @override
  void initState() {
    super.initState();
    futureBookRentals = ApiService.getBookRentals();
  }

  void _refreshRentals() {
    setState(() {
      futureBookRentals = ApiService.getBookRentals();
    });
  }

  Future<bool?> _confirmDeleteRental(int id, String bookName, String readerName) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Удалить запись о выдаче'),
        content: Text('Вы уверены, что хотите удалить запись о выдаче книги "$bookName" читателю "$readerName"?'),
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
      await ApiService.deleteBookRental(id);
      _refreshRentals();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Запись о выдаче удалена')),
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
            MaterialPageRoute(builder: (context) => const AddRentalScreen()),
          );
          if (result == true) {
            _refreshRentals();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<BookRental>>(
        future: futureBookRentals,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                BookRental rental = snapshot.data![index];
                return Dismissible(
                  key: Key('rental_${rental.id}'),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await _confirmDeleteRental(
                      rental.id!,
                      rental.book?.name ?? 'Неизвестная книга',
                      '${rental.reader?.name ?? ''} ${rental.reader?.lastname ?? ''}'.trim()
                    );
                  },
                  child: ListTile(
                    title: Text('Книга: ${rental.book?.name ?? 'N/A'}'),
                    subtitle: Text('Читатель: ${rental.reader?.name ?? 'N/A'} ${rental.reader?.lastname ?? ''}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteRental(
                        rental.id!,
                        rental.book?.name ?? 'Неизвестная книга',
                        '${rental.reader?.name ?? ''} ${rental.reader?.lastname ?? ''}'.trim()
                      ),
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