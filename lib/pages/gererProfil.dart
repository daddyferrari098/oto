import 'package:flutter/material.dart';
import '../pageAuth/inscription/first.dart';
import '../pageServices/BdServices.dart';

class GestionProfilPage extends StatelessWidget {
  const GestionProfilPage({Key? key});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<UserData>(
      future: BdServices().getUserData(),
  builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Erreur lors de la récupération des données'),
          );
        } else {
          final userData = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Gérer votre profil',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 1,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset("assets/logo.png",height: 200.0,),
                  buildUserDataField('Prénom', userData.prenom, Icons.person),
                  const SizedBox(height: 10.0),
                  buildUserDataField('Nom', userData.nom, Icons.person),
                  const SizedBox(height: 10.0),
                  buildUserDataField('Numéro de téléphone', userData.numeroTelephone, Icons.phone),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add logic here to edit the user's profile
                    },
                    icon: Icon(Icons.edit),
                    label: const Text('Modifier le Profil'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add logic here to log out the user
                      // For example, navigate to the login page
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WelcomePage()));
                    },
                    icon: Icon(Icons.logout),
                    label: const Text('Se Déconnecter'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildUserDataField(String label, String value, IconData iconData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
