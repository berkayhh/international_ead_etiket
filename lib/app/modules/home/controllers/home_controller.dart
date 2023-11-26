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
        print(etikett.name);
        print(etikett.description);

        return pw.Container(
          height: PdfPageFormat.a6.availableHeight,
          width: PdfPageFormat.a6.availableWidth,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          etikett.name,
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontSize: 9),
                        ),
                        pw.Text(
                          etikett.description,
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontSize: 7),
                        ),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          etikett.layoutrechts,
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontSize: 7),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Mindestens haltbar bis: Siehe Verpackung",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 5),
                    ),
                    pw.Text(
                      "Importeur: " + etikett.firma,
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(fontSize: 5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ));

    Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        usePrinterSettings: true,
        format: PdfPageFormat.a6,
        name: 'etikett.pdf');
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
