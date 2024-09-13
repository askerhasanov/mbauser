import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/moto.dart';

class MotoDetailsPage extends StatelessWidget {
  final Moto moto;

  const MotoDetailsPage({super.key, required this.moto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(moto.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display moto images
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: moto.images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    moto.images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    moto.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Maker: ${moto.maker}'),
                  Text('Model: ${moto.model}'),
                  Text('Engine: ${moto.engine}'),
                  Text('Trip: ${moto.trip} km'),
                  Text('Year: ${moto.year}'),
                  const SizedBox(height: 16),
                  const Text(
                    'About:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(moto.about),
                  const SizedBox(height: 16),
                  Text(
                    'Added on: ${DateFormat.yMMMd().format(moto.dateAdded)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
