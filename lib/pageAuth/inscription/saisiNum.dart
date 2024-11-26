import 'package:flutter/material.dart';
import '../../pageServices/BdServices.dart';
import 'saisiCode.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final BdServices bdServices = BdServices();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numéro de Téléphone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Champ de saisie pour le nom
            TextField(
              controller: _firstNameController,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Entrez votre nom',
                hintStyle: const TextStyle(color: Colors.black54),
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

            // Champ de saisie pour le prénom
            TextField(
              controller: _lastNameController,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Entrez votre prénom',
                hintStyle: const TextStyle(color: Colors.black54),
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

            // Champ de saisie pour la confirmation du mot de passe
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isPasswordVisible,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Confirmez votre mot de passe',
                hintStyle: const TextStyle(color: Colors.black54),
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

            const SizedBox(height: 24.0),

            // Bouton pour valider et envoyer le code OTP
            ElevatedButton(
              onPressed: () async {
                // Vérifier que tous les champs sont remplis
                if (_firstNameController.text.isEmpty ||
                    _lastNameController.text.isEmpty ||
                    _phoneNumberController.text.isEmpty ||
                    _passwordController.text.isEmpty ||
                    _confirmPasswordController.text.isEmpty) {
                  // Afficher une boîte de dialogue d'erreur
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

                // Vérifier que le mot de passe a au moins 8 caractères
                if (_passwordController.text.length < 8) {
                  // Afficher une boîte de dialogue d'erreur
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Erreur'),
                        content: const Text('Le mot de passe doit avoir au moins 8 caractères.'),
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

                // Vérifier que les mots de passe saisis sont identiques
                if (_passwordController.text != _confirmPasswordController.text) {
                  // Afficher une boîte de dialogue d'erreur
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Erreur'),
                        content: const Text('Les mots de passe ne correspondent pas.'),
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

                // Créer l'utilisateur et le rediriger vers la page VerifyOTPPage
                String firstName = _firstNameController.text;
                String lastName = _lastNameController.text;
                String phoneNumber = '+221${_phoneNumberController.text}';
                String password = _passwordController.text;

                try {
                  await bdServices.createUserWithPhoneNumber(phoneNumber, firstName, lastName, password);

                  // Naviguez vers la page VerifyOTPPage en passant le numéro de téléphone
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyOTPPage(phoneNumber: phoneNumber, verificationId: ''),
                    ),
                  );
                } catch (e) {
                  // Afficher une boîte de dialogue d'erreur si la création de l'utilisateur a échoué
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Erreur'),
                        content: const Text('Impossible de créer l\'utilisateur. Veuillez réessayer plus tard.'),
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
                  'Valider',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
