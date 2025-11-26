import 'package:flutter/material.dart';
import '../models/reader.dart';
import '../services/api_service.dart';

class AddReaderScreen extends StatefulWidget {
  const AddReaderScreen({super.key});

  @override
  State<AddReaderScreen> createState() => _AddReaderScreenState();
}

class _AddReaderScreenState extends State<AddReaderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  Future<void> _addReader() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await ApiService.addReader(Reader(
          name: _nameController.text.trim(),
          lastname: _lastnameController.text.trim(),
        ));
        
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка при добавлении читателя: $e'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить читателя'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Имя',
                  border: OutlineInputBorder(),
                  hintText: 'Введите имя читателя',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Пожалуйста, введите имя';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastnameController,
                decoration: const InputDecoration(
                  labelText: 'Фамилия',
                  border: OutlineInputBorder(),
                  hintText: 'Введите фамилию читателя',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Пожалуйста, введите фамилию';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _addReader,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Добавить читателя',
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
      ),
    );
  }
}