
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserData {
  String userId;
  String prenom;
  String nom;
  String numeroTelephone;

  UserData({
    required this.userId,
    required this.prenom,
    required this.nom,
    required this.numeroTelephone,
  });
}

class Annonce {
  final String id;
  final String modele;
  final List<String> photos; // Liste des URLs de téléchargement des images
  final int prixLocation;
  final String consommation;
  final String cylindree;
  final DateTime dateDebut;
  final DateTime dateFin;

  Annonce({
    required this.id,
    required this.modele,
    required this.photos,
    required this.prixLocation,
    required this.consommation,
    required this.cylindree,
    required this.dateDebut,
    required this.dateFin,
  });
}

class BdServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? getCurrentUserId() {
    User? currentUser = _firebaseAuth.currentUser;
    return currentUser?.uid;
  }

  // Fonction pour envoyer le code OTP
  Future<void> sendOTP(String phoneNumber, Function(String) codeSent) async {
    // Utilisez _firebaseAuth.verifyPhoneNumber() pour envoyer le code OTP
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Cette fonction est appelée automatiquement lorsque le code de vérification est reçu
        // Vous pouvez choisir de l'utiliser pour la connexion automatique, si vous le souhaitez
      },
      verificationFailed: (FirebaseAuthException e) {
        // Gérer les erreurs de vérification ici, par exemple, le numéro de téléphone invalide
        print('Erreur de vérification : ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Appel de la fonction de rappel avec l'ID de vérification
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Cette fonction est appelée lorsque le code de vérification est automatiquement récupéré après un délai
        // Vous pouvez enregistrer verificationId et utiliser pour vérifier le code plus tard
        print(
            'Code de vérification automatiquement récupéré. Verification ID : $verificationId');
      },
      timeout: const Duration(
          seconds: 60), // Temps d'attente pour l'envoi du code, en secondes
    );
  }

  // Fonction pour vérifier le code OTP
  Future<bool> verifyOTP(
    String verificationId,
    String smsCode,
  ) async {
    try {
      // Utiliser la méthode signInWithCredential pour vérifier le code OTP
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      return true;
    } catch (e) {
      print('Erreur lors de la vérification du code OTP : $e');
      return false;
    }
  }

  // Fonction pour créer un nouvel utilisateur avec les informations fournies
  Future<void> createUserWithPhoneNumber(String phoneNumber, String firstName,
      String lastName, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: '$phoneNumber@phone.oto', password: password);
      User? user = userCredential.user;
      if (user != null) {
        // L'utilisateur a été créé avec succès, vous pouvez enregistrer les autres informations dans Firestore
        // Par exemple, vous pouvez créer une collection "users" et ajouter les détails de l'utilisateur
        await _firestore.collection('users').doc(user.uid).set({
          'phoneNumber': phoneNumber,
          'firstName': firstName,
          'lastName': lastName,
        });
      }
    } catch (e) {
      print('Erreur lors de la création de l\'utilisateur : $e');
      rethrow; // Facultatif : Relancer l'exception pour la gérer dans le code appelant
    }
  }

  // Fonction pour connecter l'utilisateur avec son numéro de téléphone et son mot de passe
  Future<bool> loginUserWithPhoneNumberAndPassword(
      String phoneNumber, String password) async {
    try {
      // Utiliser la méthode signInWithEmailAndPassword pour connecter l'utilisateur
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: '$phoneNumber@phone.oto',
        password: password,
      );

      User? user = userCredential.user;
      return user != null;
    } catch (e) {
      print('Erreur lors de la connexion de l\'utilisateur : $e');
      return false;
    }
  }

  /// Fonction pour vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Fonction pour sauvegarder le jeton d'accès ou cookie localement
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', token);
  }

  // Fonction pour récupérer le jeton d'accès ou cookie stocké localement
  // Fonction pour récupérer le token de l'utilisateur connecté
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken') ?? '';
  }

  // Fonction pour supprimer le jeton d'accès ou cookie stocké localement
  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
  }

  // Fonction pour récupérer les données de l'utilisateur à partir de Firebase

Future<UserData> getUserData() async {
  try {
    String? userId = getCurrentUserId();

    if (userId == null || userId.isEmpty) {
      throw Exception('Utilisateur non connecté');
    }

    DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    UserData userData = UserData(
      userId: userId,
      prenom: data['firstName'] ?? '',
      nom: data['lastName'] ?? '',
      numeroTelephone: data['phoneNumber'] ?? '',
    );

    return userData;
  } catch (e) {
    print('Erreur lors de la récupération des données utilisateur : $e');
    rethrow;
  }
}



  // Fonction pour télécharger les images vers Firebase Storage
  // Méthode pour télécharger les images vers Firebase Storage et obtenir les URLs de téléchargement
  static Future<List<String>> _uploadImagesToStorage(List<String> photos) async {
    List<String> imageUrls = [];

    try {
      for (String imagePath in photos) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('annonces')
            .child(fileName);

        UploadTask uploadTask = storageReference.putFile(File(imagePath));
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }
    } catch (e) {
      print('Erreur lors de l\'envoi des images vers Firebase Storage : $e');
      throw Exception('Erreur lors de l\'envoi des images.');
    }

    return imageUrls;
  }


  static Future<void> sauvegarderAnnonce({
    required List<String> photos,
    required String modele,
    required int prixLocation,
    required String consommation,
    required String cylindree,
    required DateTime dateDebut,
    required DateTime dateFin,
  }) async {
    try {
      // Vérifier si l'utilisateur est connecté avant de sauvegarder l'annonce
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Utilisateur non connecté");
      }

      // Télécharger les images vers Firebase Storage et obtenir les URLs de téléchargement
      List<String> imageUrls = await _uploadImagesToStorage(photos);

      // Ajouter un nouveau document dans la collection "Annonces" avec un identifiant généré automatiquement
      DocumentReference annonceRef =
          await FirebaseFirestore.instance.collection('Annonces').add({
        'userId': user.uid,
        'photos': imageUrls, // Enregistrer les URLs des images dans Firestore
        'modele': modele,
        'prixLocation': prixLocation,
        'consommation': consommation,
        'cylindree': cylindree,
        'dateDebut': dateDebut,
        'dateFin': dateFin,
      });

      // Récupérer l'identifiant généré pour l'annonce et le mettre à jour dans la base de données
      await annonceRef.update({
        'id': annonceRef.id,
      });
    } catch (e) {
      // Gérer les erreurs éventuelles
      throw Exception('Erreur lors de la sauvegarde de l\'annonce : $e');
    }
  }
  // ... Autres fonctions de la classe ...
  // Fonction pour supprimer une annonce à partir de son ID
  Future<void> removeAnnonce(String annonceId) async {
    try {
      // Vérifier si l'utilisateur est connecté avant de supprimer l'annonce
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Utilisateur non connecté");
      }

      // Supprimer le document correspondant à l'ID de l'annonce dans la collection "Annonces"
      await FirebaseFirestore.instance.collection('Annonces').doc(annonceId).delete();
    } catch (e) {
      // Gérer les erreurs éventuelles
      throw Exception('Erreur lors de la suppression de l\'annonce : $e');
    }
  }

  // La fonction getAnnonces() retournera un Stream d'annonces en temps réel, ce qui nous permettra de recevoir des mises à jour
  // automatiques chaque fois qu'une annonce est ajoutée, modifiée ou supprimée dans la base de données.
  Stream<List<Annonce>> getAnnonces() {
    return FirebaseFirestore.instance
        .collection('Annonces')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Annonce(
          id: doc.id, // Utiliser l'identifiant du document comme ID de l'annonce
          modele: doc['modele'],
          photos: List<String>.from(doc['photos']),
          prixLocation: doc['prixLocation'],
          consommation: doc['consommation'],
          cylindree: doc['cylindree'],
          dateDebut: (doc['dateDebut'] as Timestamp).toDate(),
          dateFin: (doc['dateFin'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  // Fonction pour modifier une annonce existante
  static Future<void> modifierAnnonce({
    required String annonceId, // ID de l'annonce à modifier
    required List<String> photos,
    required String modele,
    required int prixLocation,
    required String consommation,
    required String cylindree,
    required DateTime dateDebut,
    required DateTime dateFin,
  }) async {
    try {
      // Vérifier si l'utilisateur est connecté avant de modifier l'annonce
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Utilisateur non connecté");
      }

      // Télécharger les images vers Firebase Storage et obtenir les URLs de téléchargement
      List<String> imageUrls = await _uploadImagesToStorage(photos);

      // Mettre à jour les données de l'annonce dans Firestore
      await FirebaseFirestore.instance.collection('Annonces').doc(annonceId).update({
        'userId': user.uid,
        'photos': imageUrls, // Enregistrer les URLs des images dans Firestore
        'modele': modele,
        'prixLocation': prixLocation,
        'consommation': consommation,
        'cylindree': cylindree,
        'dateDebut': dateDebut,
        'dateFin': dateFin,
      });
    } catch (e) {
      // Gérer les erreurs éventuelles
      throw Exception('Erreur lors de la modification de l\'annonce : $e');
    }
  }

  // Fonction pour rechercher les annonces en fonction des critères saisis par l'utilisateur
  Stream<List<Annonce>> rechercherAnnonces({
    String? modele,
    int? prixMin,
    int? prixMax,
    int? nombreCV,
    DateTime? dateDisponibilite,
  }) {
    // Créer une requête Firestore pour filtrer les annonces en fonction des critères de recherche
    Query query = FirebaseFirestore.instance.collection('Annonces');

    if (modele != null && modele.isNotEmpty) {
      query = query.where('modele', isEqualTo: modele);
    }

    if (prixMin != null) {
      query = query.where('prixLocation', isGreaterThanOrEqualTo: prixMin);
    }

    if (prixMax != null) {
      query = query.where('prixLocation', isLessThanOrEqualTo: prixMax);
    }

    if (nombreCV != null) {
      query = query.where('nombreCV', isEqualTo: nombreCV);
    }

    if (dateDisponibilite != null) {
      query = query.where('dateDebut', isLessThanOrEqualTo: dateDisponibilite);
      query = query.where('dateFin', isGreaterThanOrEqualTo: dateDisponibilite);
    }

    // Renvoyer un Stream de la liste des annonces filtrées
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Annonce(
          id: doc.id,
          modele: doc['modele'],
          photos: List<String>.from(doc['photos']),
          prixLocation: doc['prixLocation'],
          consommation: doc['consommation'],
          cylindree: doc['cylindree'],
          dateDebut: (doc['dateDebut'] as Timestamp).toDate(),
          dateFin: (doc['dateFin'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}

