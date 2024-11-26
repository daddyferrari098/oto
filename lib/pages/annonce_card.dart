import 'package:flutter/material.dart';
import '../pageServices/BdServices.dart';
import 'detailAnnoncePage.dart';

class AnnonceCard extends StatelessWidget {
  final Annonce annonce;

  AnnonceCard(this.annonce);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnnonceDetailsPage(annonce: annonce),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.network(annonce.photos[0], fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    annonce.modele,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('${annonce.prixLocation} FCFA par jour'),
                  SizedBox(height: 8),
                  Text(
                    'Disponible le ${annonce.dateDebut.day}/${annonce.dateDebut.month}/${annonce.dateDebut.year}',
                    style: TextStyle(fontStyle: FontStyle.italic),
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
