import 'package:flutter/material.dart';
import '../pageServices/BdServices.dart';
import 'detailAnnoncePage.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();

  static List<Annonce> favoriteList = [];
  
  static void addFavorite(Annonce annonce) {
    favoriteList.add(annonce);
  }
  
  static void removeFavorite(Annonce annonce) {
    favoriteList.remove(annonce);
  }
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Annonces favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: FavoritePage.favoriteList.length,
        itemBuilder: (context, index) {
          Annonce annonce = FavoritePage.favoriteList[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  annonce.photos[0],
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                annonce.modele,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${annonce.prixLocation} FCFA par jour',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    FavoritePage.removeFavorite(annonce);
                  });
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnnonceDetailsPage(annonce: annonce),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
