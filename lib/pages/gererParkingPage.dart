import 'package:flutter/material.dart';
import 'editionAnnoncePage.dart';
import '../pageServices/BdServices.dart';

class GererParkingPage extends StatefulWidget {
  const GererParkingPage({Key? key}) : super(key: key);

  @override
  _GererParkingPageState createState() => _GererParkingPageState();
}

class _GererParkingPageState extends State<GererParkingPage> {
  final BdServices _bdServices = BdServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gérer votre parking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<List<Annonce>>(
        stream: _bdServices.getAnnonces(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final annonces = snapshot.data!;
            return ListView.builder(
              itemCount: annonces.length,
              itemBuilder: (context, index) {
                return _buildAnnonceCard(annonces[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur lors de la récupération des annonces.'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildAnnonceCard(Annonce annonce) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditionAnnoncePage(annonce: annonce),
          ),
        );
      },
      child: Card(
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(annonce.photos.isNotEmpty
                      ? annonce.photos[0]
                      : 'default_image_url'), // Default image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Modèle: ${annonce.modele}'),
                  Text(
                    'Date de disponibilité: ${annonce.dateDebut.day}/${annonce.dateDebut.month}/${annonce.dateDebut.year} - ${annonce.dateFin.day}/${annonce.dateFin.month}/${annonce.dateFin.year}',
                  ),
                  Text('Prix de location: ${annonce.prixLocation} CFA'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditionAnnoncePage(annonce: annonce),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Supprimer l\'annonce'),
                      content: const Text('Êtes-vous sûr de vouloir supprimer cette annonce ?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _bdServices.removeAnnonce(annonce.id);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Supprimer'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
