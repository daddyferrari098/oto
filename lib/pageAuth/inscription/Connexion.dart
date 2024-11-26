import 'package:flutter/material.dart';
import 'package:oto/pageAuth/inscription/saisiNum.dart';
import '../../pageServices/BdServices.dart';
import '../../pages/AcceuilPage.dart'; // Import de la page d'accueil (ou une autre page après la connexion)

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final BdServices bdServices = BdServices();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               Image.asset("assets/logo.png",height: 200.0,),
              Text(
                'Connectez-vous à votre compte',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              // Champ de saisie pour le numéro de téléphone avec le country code
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Entrez votre numéro de téléphone', // Indication pour l'utilisateur
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag, size: 28, color: Colors.black), // Icône de drapeau du Sénégal
                      SizedBox(width: 8.0),
                      Text(
                        '+221', // Country Code du Sénégal
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
                SizedBox(
                  height: 20.0,
                ),
              // Champ de saisie pour le mot de passe
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Entrez votre mot de passe',
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  // Icône pour montrer/masquer le mot de passe
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
      
              const SizedBox(height: 24.0),
      
              // Bouton pour se connecter
              ElevatedButton(
                onPressed: () async {
                  // Vérifier que les champs sont remplis
                  if (_phoneNumberController.text.isEmpty || _passwordController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Erreur'),
                          content: const Text('Veuillez remplir tous les champs.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
      
                  // Connecter l'utilisateur
                  String phoneNumber = '+221${_phoneNumberController.text}';
                  String password = _passwordController.text;
      
                  bool isLoggedIn = await bdServices.loginUserWithPhoneNumberAndPassword(phoneNumber, password);
      
                  if (isLoggedIn) {
                    // Naviguer vers la page d'accueil après connexion réussie
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DieukaDiot(), // Remplace la page actuelle par la page d'accueil
                      ),
                    );
                  } else {
                    // Afficher un message d'erreur si la connexion échoue
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Erreur'),
                          content: const Text('Le numéro de téléphone ou le mot de passe est incorrect.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Se connecter',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Naviguer vers la page d'inscription lorsque le lien est cliqué
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PhoneNumberPage()), // Remplacez InscriptionPage par le nom de votre page d'inscription
                  );
                },
                child: Text(
                  'Pas de compte, inscrivez-vous ici',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
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
