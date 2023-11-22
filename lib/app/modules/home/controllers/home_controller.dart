import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var depo = GetStorage();
  var produkte = <Etikett>[].obs;

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController layoutrechts = TextEditingController();
  TextEditingController quantity = TextEditingController();
  var firma = 'International Trading EAD'.obs;
  void addProdukt(Etikett etikett) {
    produkte.add(etikett);
    var save = produkte.toJson();
    depo.write('produkte', save);
  }

  void removeProdukt(Etikett etikett) {
    produkte.remove(etikett);
    var save = produkte.toJson();
    depo.write('produkte', save);
  }

  void getProdukte() {
    var get = depo.read('produkte');
    if (get != null) {
      produkte.addAll((get as List).map((e) => Etikett.fromJson(e)).toList());
    }
  }

  void printEtiket(int id, int quantity) {
    var etikett = produkte.firstWhere((element) => element.id == id);
    print(etikett.name);
    print(etikett.description);
    print(etikett.firma);
    print(etikett.layoutrechts);
  }

  @override
  void onInit() {
    super.onInit();
    getProdukte();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class Etikett {
  int id;
  String name;
  String description;
  String firma;
  String layoutrechts;

  Etikett(
      {required this.id,
      required this.name,
      required this.description,
      required this.firma,
      required this.layoutrechts});

  // Define the fromJson constructor
  factory Etikett.fromJson(Map<String, dynamic> json) {
    return Etikett(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      firma: json['firma'],
      layoutrechts: json['layoutrechts'],
    );
  }
}
