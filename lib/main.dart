import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oto/pageAuth/inscription/Connexion.dart';
import 'package:provider/provider.dart';
import 'package:oto/pages/AcceuilPage.dart';
import 'package:oto/pageServices/BdServices.dart';
import 'package:oto/pageServices/auth_provider.dart'; // Import your file containing AuthProvider

void main() async {
  // Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BdServices bdServices = BdServices();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location de Voitures',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder<String>(
          future: bdServices.getToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final accessToken = snapshot.data;
              if (accessToken != null) {
                // Utilisateur déjà connecté, redirigez-le vers la page d'accueil
                return const DieukaDiot();
              } else {
                // Utilisateur non connecté, redirigez-le vers la page de connexion
                return const LoginPage();
              }
            } else {
              // Affichez un indicateur de chargement si nécessaire
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
