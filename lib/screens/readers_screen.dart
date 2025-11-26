import 'package:flutter/material.dart';
import '../models/reader.dart';
import '../services/api_service.dart';
import 'add_reader_screen.dart';

class ReadersScreen extends StatefulWidget {
  const ReadersScreen({super.key});

  @override
  State<ReadersScreen> createState() => _ReadersScreenState();
}

class _ReadersScreenState extends State<ReadersScreen> {
  late Future<List<Reader>> futureReaders;

  @override
  void initState() {
    super.initState();
    futureReaders = ApiService.getReaders();
  }

  void _refreshReaders() {
    setState(() {
      futureReaders = ApiService.getReaders();
    });
  }

  Future<bool?> _confirmDeleteReader(int id, String name, String lastname) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Удалить читателя'),
        content: Text('Вы уверены, что хотите удалить читателя "$name $lastname"?'),
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
      await ApiService.deleteReader(id);
      _refreshReaders();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Читатель "$name $lastname" удален')),
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
            MaterialPageRoute(builder: (context) => const AddReaderScreen()),
          );
          if (result == true) {
            _refreshReaders();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Reader>>(
        future: futureReaders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Reader reader = snapshot.data![index];
                return Dismissible(
                  key: Key('reader_${reader.id}'),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await _confirmDeleteReader(
                      reader.id!, 
                      reader.name ?? '', 
                      reader.lastname ?? ''
                    );
                  },
                  child: ListTile(
                    title: Text('${reader.name ?? ''} ${reader.lastname ?? ''}'.trim()),
                    subtitle: Text('ID: ${reader.id ?? 'N/A'}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteReader(
                        reader.id!, 
                        reader.name ?? '', 
                        reader.lastname ?? ''
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