import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
    depo.write(
        'produkte',
        produkte
            .map((e) => e.toJson())
            .toList()); // Tüm ürünleri JSON formatına dönüştür ve kaydet
    Get.back();
  }

  void removeProdukt(Etikett etikett) {
    produkte.remove(etikett);
    var save = produkte.toJson();
    depo.write('produkte', save);
  }

  void editProduct(Etikett etikett) {
    produkte.add(etikett);
    var save = produkte.toJson();
    depo.write('produkte', save);
  }

  getProdukte() {
    print('getProdukte');
    print(depo.read('produkte'));
    var get = depo.read('produkte');
    if (get != null) {
      produkte.addAll((get as List).map((e) => Etikett.fromJson(e)).toList());
    }
  }

  void printEtiket(int id, int quantity) {
    Get.back();
    var etikett = produkte.firstWhere((element) => element.id == id);

    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a6,
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.SizedBox(
                  width: PdfPageFormat.a6.width / 2,
                  child: pw.Column(children: [
                    pw.Text(etikett.name),
                    pw.Text(etikett.description),
                  ]),
                ),
                pw.SizedBox(
                  width: PdfPageFormat.a6.width / 2,
                  child: pw.Column(children: [
                    pw.Text(etikett.layoutrechts),
                  ]),
                ),
              ]); // Center
        }));

    Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        name: 'my_etikett.pdf');
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await getProdukte();
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

  Etikett({
    required this.id,
    required this.name,
    required this.description,
    required this.firma,
    required this.layoutrechts,
  });

  // JSON formatına dönüştürme işlevi
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'firma': firma,
      'layoutrechts': layoutrechts,
    };
  }

  // JSON'dan nesneyi oluşturma işlevi
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
