import 'package:flutter/material.dart';
import '../models/book_rental.dart';
import '../services/api_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookRental>>(
      future: futureBookRentals,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              BookRental rental = snapshot.data![index];
              return ListTile(
                title: Text('Book: ${rental.book?.name ?? 'N/A'}'),
                subtitle: Text('Reader: ${rental.reader?.name ?? 'N/A'} ${rental.reader?.lastname ?? ''}'),
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