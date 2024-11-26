import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../pageServices/BdServices.dart';

class EditionAnnoncePage extends StatefulWidget {
  final Annonce annonce;

  const EditionAnnoncePage({Key? key, required this.annonce}) : super(key: key);

  @override
  _EditionAnnoncePageState createState() => _EditionAnnoncePageState();
}

class _EditionAnnoncePageState extends State<EditionAnnoncePage> {
  final TextEditingController _modeleController = TextEditingController();
  final TextEditingController _prixLocationController = TextEditingController();
  String _consommation = 'Essence';
  String _cylindree = '4cv';
  DateTime _dateDebut = DateTime.now();
  DateTime _dateFin = DateTime.now().add(Duration(days: 1));

  String _image1 = '';
  String _image2 = '';
  String _image3 = '';

  @override
  void initState() {
    super.initState();
    _modeleController.text = widget.annonce.modele;
    _prixLocationController.text = widget.annonce.prixLocation.toString();
    _consommation = widget.annonce.consommation;
    _cylindree = widget.annonce.cylindree;
    _dateDebut = widget.annonce.dateDebut;
    _dateFin = widget.annonce.dateFin;
    _image1 = widget.annonce.photos[0];
    _image2 = widget.annonce.photos[1];
    _image3 = widget.annonce.photos[2];
  }

  @override
  void dispose() {
    _modeleController.dispose();
    _prixLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Édition de l\'Annonce'),
        backgroundColor: Colors.black, // Couleur de la barre d'app bar en noir
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildImageFormField(
                'Image 1',
                _image1,
                (imagePath) {
                  setState(() {
                    _image1 = imagePath;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildImageFormField(
                'Image 2',
                _image2,
                (imagePath) {
                  setState(() {
                    _image2 = imagePath;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildImageFormField(
                'Image 3',
                _image3,
                (imagePath) {
                  setState(() {
                    _image3 = imagePath;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _modeleController,
                decoration: InputDecoration(
                  labelText: 'Modèle de la voiture',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 20),
              _buildDropDownFormField(
                'Consommation',
                _consommation,
                ['Essence', 'Gazoil'],
                (value) {
                  setState(() {
                    _consommation = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildDropDownFormField(
                'Cylindrée',
                _cylindree,
                ['4cv', '6cv', '8cv', '10cv'],
                (value) {
                  setState(() {
                    _cylindree = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildDatePickerFormField(
                'Date de début de disponibilité',
                _dateDebut,
                (date) {
                  setState(() {
                    _dateDebut = date;
                  });
                },
              ),
              const SizedBox(height: 20),
               _buildDatePickerFormField(
                'Date de fin de disponibilité',
                _dateFin,
                (date) {
                  setState(() {
                    _dateFin = date;
                  });
                },
              ),
              const SizedBox(height: 20),
             
              ElevatedButton(
                onPressed: () {
                  sauvegarderAnnonce();
                  
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Couleur du bouton en noir
                ),
                child: const Text('Enregistrer les modifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour afficher un menu déroulant pour sélectionner un élément parmi une liste d'éléments
  Widget _buildDropDownFormField(
    String label,
    String value,
    List<String> items,
    void Function(String)? onChanged,
  ) {
    return TextFormField(
      readOnly: true,
      onTap: () {
        _showDropDown(context, value, items, onChanged);
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        filled: true,
        fillColor: Colors.grey[300],
      ),
      initialValue: value,
    );
  }

  // Méthode pour afficher le menu déroulant et récupérer la valeur choisie
  void _showDropDown(
    BuildContext context,
    String value,
    List<String> items,
    void Function(String)? onChanged,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: 200, // Hauteur fixe
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  onTap: () {
                    if (onChanged != null) {
                      onChanged(items[index]);
                    }
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Méthode pour afficher un sélecteur de date pour choisir une date
  Widget _buildDatePickerFormField(
    String label,
    DateTime selectedDate,
    void Function(DateTime) onChanged,
  ) {
    return TextFormField(
      readOnly: true,
      onTap: () {
        _showDatePicker(context, selectedDate, onChanged);
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        filled: true,
        fillColor: Colors.grey[300],
      ),
      initialValue: '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
    );
  }

  // Méthode pour afficher un sélecteur de date et récupérer la date choisie
  Future<void> _showDatePicker(
    BuildContext context,
    DateTime selectedDate,
    void Function(DateTime) onChanged,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        onChanged(pickedDate);
      });
    }
  }

  // Méthode pour afficher un champ d'image et permettre à l'utilisateur de sélectionner une image depuis la galerie
  Widget _buildImageFormField(
    String label,
    String imageURL,
    void Function(String) onChanged,
  ) {
    return GestureDetector(
      onTap: () {
        _showImageEditDialog(context, onChanged);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[300],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.black, // Couleur du texte en noir
              ),
            ),
            imageURL.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: FileImage(File(imageURL)),
                    radius: 25,
                  )
                : Icon(Icons.add_a_photo, color: Colors.black), // Couleur de l'icône en noir
          ],
        ),
      ),
    );
  }

  // Méthode pour afficher un dialogue de sélection d'image depuis la galerie
  void _showImageEditDialog(
    BuildContext context,
    void Function(String) onChanged,
  ) async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      onChanged(pickedImage.path);
    }
  }

  void sauvegarderAnnonce() async {
  try {
    await BdServices.modifierAnnonce(
      annonceId: widget.annonce.id,
      photos: [_image1, _image2, _image3],
      modele: _modeleController.text,
      prixLocation: int.parse(_prixLocationController.text),
      consommation: _consommation,
      cylindree: _cylindree,
      dateDebut: _dateDebut,
      dateFin: _dateFin,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sauvegarde réussie'),
          content: const Text('Les modifications ont été sauvegardées avec succès.'),
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
  } catch (e) {
    print('Erreur lors de la sauvegarde de l\'annonce : $e');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: const Text('Une erreur s\'est produite lors de la sauvegarde de l\'annonce.'),
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
}

}
