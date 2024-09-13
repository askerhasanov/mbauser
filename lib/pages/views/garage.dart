import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../elements/colors.dart';
import '../../elements/pageheader.dart';
import '../../models/moto.dart';
import 'motoDetails.dart';
import 'motoThumbnail.dart';


class GaragePage extends StatefulWidget {
  const GaragePage({super.key});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref('motors');
  List<Moto> _motos = [];

  @override
  void initState() {
    super.initState();
    _fetchMotos();
  }

  void _fetchMotos() {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Moto> loadedMotos = [];
        data.forEach((key, value) {
          loadedMotos.add(Moto.fromMap(value)); // Fixed fromMap
        });
        loadedMotos.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
        setState(() {
          _motos = loadedMotos;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MbaColors.light,
      child: Column(
        children: [
          // Header
          const pageHeader(text: 'Garage'),
          Expanded(
            child: _motos.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              itemCount: _motos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4, // Adjust thumbnail size
              ),
              itemBuilder: (context, index) {
                final moto = _motos[index];
                return MotoThumbnail(
                  moto: moto,
                  onTap: () {
                    // Navigate to details page on tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MotoDetailsPage(moto: moto),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}




