import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart'; // Importer le package des icônes personnalisées
import '../pageServices/BdServices.dart';
import 'FavoritePage.dart';

class AnnonceDetailsPage extends StatefulWidget {
  final Annonce annonce;

  AnnonceDetailsPage({required this.annonce});

  @override
  _AnnonceDetailsPageState createState() => _AnnonceDetailsPageState();
}

class _AnnonceDetailsPageState extends State<AnnonceDetailsPage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'annonce'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Container(
                width: 350,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
                ),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: widget.annonce.photos.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.network(
                        widget.annonce.photos[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.annonce.photos.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.black : Colors.grey,
                  ),
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.annonce.modele,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(FontAwesome.money, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              '${widget.annonce.prixLocation} FCFA par jour',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(FontAwesome.calendar, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              'Du ${widget.annonce.dateDebut.day}/${widget.annonce.dateDebut.month}/${widget.annonce.dateDebut.year} au ${widget.annonce.dateFin.day}/${widget.annonce.dateFin.month}/${widget.annonce.dateFin.year}',
                              style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(FontAwesome.tachometer, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              'Consommation: ${widget.annonce.consommation}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(FontAwesome.car, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              'Cylindrée: ${widget.annonce.cylindree}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                        if (_isFavorite) {
                          // Ajouter l'annonce à la liste des favoris
                          FavoritePage.addFavorite(widget.annonce);
                        } else {
                          // Supprimer l'annonce de la liste des favoris
                          FavoritePage.removeFavorite(widget.annonce);
                        }
                      });
                    },
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Implémenter la logique pour ouvrir l'application WhatsApp avec le numéro du propriétaire
                      print('Ouvrir WhatsApp');
                    },
                    child: Column(
                      children: [
                        Icon(FontAwesome.whatsapp, color: Colors.green, size: 30),
                        SizedBox(height: 8),
                        Text('WhatsApp'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Implémenter la logique pour ouvrir l'application d'appel téléphonique avec le numéro du propriétaire
                      print('Appel téléphonique');
                    },
                    child: Column(
                      children: [
                        Icon(Icons.phone, color: Colors.blue, size: 30),
                        SizedBox(height: 8),
                        Text('Appel'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Implémenter la logique pour ouvrir l'application de messagerie avec le numéro du propriétaire
                      print('Message');
                    },
                    child: Column(
                      children: [
                        Icon(Icons.message, color: Colors.orange, size: 30),
                        SizedBox(height: 8),
                        Text('Message'),
                      ],
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
