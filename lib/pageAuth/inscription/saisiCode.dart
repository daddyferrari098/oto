import 'package:flutter/material.dart';
import '../../pageServices/BdServices.dart';
import '../../pages/AcceuilPage.dart'; // Import de la page AccueilPage

class VerifyOTPPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber; // Ajout du paramètre phoneNumber

  const VerifyOTPPage({super.key, required this.verificationId, required this.phoneNumber});

  @override
  _VerifyOTPPageState createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  final TextEditingController _otpController = TextEditingController();
  final BdServices bdServices = BdServices();
  bool _isNavigated = false; // Variable pour vérifier si l'utilisateur a déjà été redirigé

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification du Code OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Champ de saisie pour le code de vérification
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Entrez le Code de Vérification',
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
            // Bouton pour valider et vérifier le code OTP
            ElevatedButton(
              onPressed: () async {
                String smsCode = _otpController.text;
                bool verificationSuccess = await bdServices.verifyOTP(widget.verificationId, smsCode);

                if (verificationSuccess && !_isNavigated) {
                  // Rediriger vers la page AccueilPage en passant le phoneNumber
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DieukaDiot(),
                    ),
                  );
                  _isNavigated = true;
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
                  'Vérifier',
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
