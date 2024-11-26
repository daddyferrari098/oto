import 'package:flutter/material.dart';
import 'package:oto/pageAuth/inscription/saisiNum.dart';
import 'package:oto/pages/AcceuilPage.dart';
import 'Connexion.dart';
import 'package:provider/provider.dart';
import '../../pageServices/auth_provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Accéder au gestionnaire d'état de connexion
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Vérifier si l'utilisateur est déjà connecté
    if (authProvider.isLoggedIn) {
      // Rediriger directement vers la page d'accueil si l'utilisateur est connecté
      return const DieukaDiot();
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/im2.png"),
        fit: BoxFit.cover, // Ajuste l'image pour couvrir tout le conteneur
      ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png",height: 200.0,),
              Text(
                'Bienvenue la où la solution à ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'vos besoin de mobilité se trouve',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Rediriger vers la page d'inscription (PhoneNumberPage)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhoneNumberPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(300, 50), // Définir la taille minimale du bouton
                  padding: EdgeInsets.symmetric(horizontal: 20), // Ajouter du padding horizontal
                ),
                child: Text(
                  'Inscription',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Rediriger vers la page de connexion (LoginPage)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(300, 50), // Définir la taille minimale du bouton
                  padding: EdgeInsets.symmetric(horizontal: 20), // Ajouter du padding horizontal
                ),
                child: Text(
                  'Connexion',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}