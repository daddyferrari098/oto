import 'package:flutter/material.dart';
import '../pageServices/BdServices.dart';
import 'annonce_card.dart';
import 'creerAnnoncePage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BdServices bdServices = BdServices();

  String? modele;
  int? prixMin;
  int? prixMax;
  DateTime? dateDisponibilite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Oto',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => RechercheAnnonceDialog(),
              ).then((value) {
                if (value != null && value is Map<String, dynamic>) {
                  setState(() {
                    modele = value['modele'];
                    prixMin = value['prixMin'];
                    prixMax = value['prixMax'];
                    dateDisponibilite = value['dateDisponibilite'];
                  });
                }
              });
            },
            icon: Icon(Icons.search),
            tooltip: 'Rechercher',
          ),
        ],
      ),
      body: StreamBuilder<List<Annonce>>(
        stream: bdServices.rechercherAnnonces(
          modele: modele,
          prixMin: prixMin,
          prixMax: prixMax,
          dateDisponibilite: dateDisponibilite,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Annonce> annonces = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: annonces.length,
                    itemBuilder: (context, index) {
                      return buildAnnonceCard(context, annonces[index]);
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreerAnnoncePage()),
          );
        },
        child: Icon(Icons.car_crash),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget buildAnnonceCard(BuildContext context, Annonce annonce) {
    return AnnonceCard(annonce);
  }
}

class RechercheAnnonceDialog extends StatefulWidget {
  @override
  _RechercheAnnonceDialogState createState() => _RechercheAnnonceDialogState();
}

class _RechercheAnnonceDialogState extends State<RechercheAnnonceDialog> {
  final _formKey = GlobalKey<FormState>();
  String? modele;
  int? prixMin;
  int? prixMax;
  DateTime? dateDisponibilite;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Rechercher une annonce'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Modèle'),
                onChanged: (value) {
                  setState(() {
                    modele = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prix minimum'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    prixMin = int.tryParse(value);
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prix maximum'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    prixMax = int.tryParse(value);
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date de disponibilité (AAAA-MM-JJ)'),
                onChanged: (value) {
                  setState(() {
                    dateDisponibilite = DateTime.tryParse(value);
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {
              Map<String, dynamic> criteres = {
                'modele': modele,
                'prixMin': prixMin,
                'prixMax': prixMax,
                'dateDisponibilite': dateDisponibilite,
              };
              Navigator.pop(context, criteres);
            },
            child: Text('Rechercher'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Annuler'),
          ),
        ],
      ),
    );
  }
}
