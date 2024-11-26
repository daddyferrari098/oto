
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import '../pageServices/BdServices.dart';

class CreerAnnoncePage extends StatefulWidget {
  const CreerAnnoncePage({Key? key}) : super(key: key);

  @override
  _CreerAnnoncePageState createState() => _CreerAnnoncePageState();
}

class _CreerAnnoncePageState extends State<CreerAnnoncePage> {
  final List<String> _photos = [];
  String _modele = '';
  int _prixLocation = 0;
  String _consommation = 'Essence';
  String _cylindree = '4cv';
  DateTime _dateDebut = DateTime.now();
  DateTime _dateFin = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Créer une annonce',
          style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Ajouter des photos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildPhotoAvatars(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Modèle de la voiture',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
                onChanged: (value) {
                  setState(() {
                    _modele = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Prix de location (CFA)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  suffixText: 'CFA',
                ),
                onChanged: (value) {
                  setState(() {
                    _prixLocation = int.tryParse(value) ?? 0;
                  });
                },
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
                'Disponibilité de la voiture (Début)',
                _dateDebut,
                (date) {
                  setState(() {
                    _dateDebut = date;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildDatePickerFormField(
                'Disponibilité de la voiture (Fin)',
                _dateFin,
                (date) {
                  setState(() {
                    _dateFin = date;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sauvegarderAnnonce,
                child: const Text('Enregistrer l\'annonce'),
                style: ElevatedButton.styleFrom(
                primary: Colors.black, // Couleur de fond du bouton
                onPrimary: Colors.white, // Couleur du texte du bouton
  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPhotoAvatars() {
    List<Widget> avatars = [];

    for (int i = 0; i < 3; i++) {
      if (i < _photos.length) {
        avatars.add(
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: Icon(Icons.add_a_photo),
          ),
        );
      } else {
        avatars.add(
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.black,
            child: IconButton(
              onPressed: _ajouterPhotos,
              icon: const Icon(Icons.add_a_photo),
              color: Colors.white,
            ),
          ),
        );
      }
    }

    return avatars;
  }

  void _ajouterPhotos() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photos.add(pickedFile.path);
      });
    }
  }

  Widget _buildDropDownFormField(
    String label,
    String value,
    List<String> items,
    void Function(String)? onChanged,
  ) {
    return TextFormField(
      readOnly: true,
      onTap: () {
        _afficherDropDown(context, items, onChanged);
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

  Widget _buildDatePickerFormField(
    String label,
    DateTime selectedDate,
    void Function(DateTime) onChanged,
  ) {
    return TextFormField(
      readOnly: true,
      onTap: () {
        _afficherDatePicker(context, selectedDate, onChanged);
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        filled: true,
        fillColor: Colors.grey[300],
      ),
      initialValue: '${selectedDate.day}/${

selectedDate.month}/${selectedDate.year}',
    );
  }

  void _afficherDropDown(
    BuildContext context,
    List<String> items,
    void Function(String)? onChanged,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
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

  void _afficherDatePicker(
    BuildContext context,
    DateTime selectedDate,
    void Function(DateTime) onChanged,
  ) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2000, 1, 1),
      maxTime: DateTime(2100, 12, 31),
      onChanged: (date) {},
      onConfirm: (date) {
        if (date != selectedDate) {
          setState(() {
            onChanged(date);
          });
        }
      },
      currentTime: selectedDate,
      locale: LocaleType.fr,
    );
  }

  void _sauvegarderAnnonce() async {
    try {
      await BdServices.sauvegarderAnnonce(
        photos: _photos,
        modele: _modele,
        prixLocation: _prixLocation,
        consommation: _consommation,
        cylindree: _cylindree,
        dateDebut: _dateDebut,
        dateFin: _dateFin,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Succès'),
            content: const Text('Votre annonce a été sauvegardée avec succès.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreerAnnoncePage(),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      setState(() {
        _photos.clear();
        _modele = '';
        _prixLocation = 0;
        _consommation = 'Essence';
        _cylindree = '4cv';
        _dateDebut = DateTime.now();
        _dateFin = DateTime.now();
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text('Une erreur est survenue lors de la sauvegarde de l\'annonce.'),
            actions: [
              ElevatedButton(
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