import 'package:flutter/material.dart';
import '../models/reader.dart';
import '../services/api_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reader>>(
      future: futureReaders,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Reader reader = snapshot.data![index];
              return ListTile(
                title: Text('${reader.name} ${reader.lastname}'),
                subtitle: Text('ID: ${reader.id}'),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}