import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FavoritePage.dart';
import 'creerAnnoncePage.dart';
import 'gererParkingPage.dart';
import 'gererProfil.dart';
import 'home.dart';

class DieukaDiot extends StatelessWidget {
  const DieukaDiot({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavigationProvider>(
      create: (context) => NavigationProvider(),
      child: const Scaffold(
        body: SafeArea(
          child: DieukaDiotBody(),
        ),
        bottomNavigationBar: DieukaDiotBottomNavigationBar(),
      ),
    );
  }
}
class NavigationProvider with ChangeNotifier {
  int selectedTab = 0;

  void changeTab(int index) {
    selectedTab = index;
    notifyListeners();
  }
}

class DieukaDiotBody extends StatelessWidget {
  const DieukaDiotBody({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return IndexedStack(
      index: navigationProvider.selectedTab,
      children:  [
        HomePage(),
        GererParkingPage(),
        CreerAnnoncePage(),
        FavoritePage(),
        GestionProfilPage(),
      ],
    );
  }
}

class DieukaDiotBottomNavigationBar extends StatelessWidget {
  const DieukaDiotBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return BottomNavigationBar(
      currentIndex: navigationProvider.selectedTab,
      onTap: (index) => navigationProvider.changeTab(index),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
        BottomNavigationBarItem(icon: Icon(Icons.car_rental), label: "Parking"),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_box), label: "Crée annonce"),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), label: "Favoris"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: "Gérer Profil"),
      ],
    );
  }
}
