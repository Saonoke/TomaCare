import 'package:flutter/cupertino.dart';
import 'package:tomacare/Models/Plant.dart';

class Plants extends ChangeNotifier {
  List<Plant> plants = [
    Plant(nama: 'Tomat 1', deskripsi: 'Jamuran', image: 'images/tomat.jpg'),
    Plant(nama: 'Tomat 2', deskripsi: 'Jamuran', image: 'images/tomat.jpg'),
  ];

  void addPlant(Plant plant) {
    plants.add(plant);
    notifyListeners();
  }
}
