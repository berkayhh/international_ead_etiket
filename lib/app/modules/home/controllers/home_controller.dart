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
    depo.write('produkte', produkte.map((e) => e.toJson()).toList());
    Get.back();
  }

  void removeProdukt(Etikett etikett) {
    produkte.remove(etikett);
    depo.write('produkte', produkte.map((e) => e.toJson()).toList());
  }

  void editProduct(Etikett etikett) {
    var index = produkte.indexWhere((element) => element.id == etikett.id);
    if (index != -1) {
      produkte[index] = etikett;
      depo.write('produkte', produkte.map((e) => e.toJson()).toList());
    }
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

    // 3.5x2 inç boyutunu tanımla (piksel cinsinden dönüşüm: 1 inç = 72 piksel)
    const customPageFormat = PdfPageFormat(3.93 * 72, 1.96 * 72);

    for (int i = 0; i < quantity; i++) {
      doc.addPage(pw.Page(
        pageFormat: customPageFormat,
        build: (pw.Context context) {
          return pw.Container(
            height: customPageFormat.availableHeight,
            width: customPageFormat.availableWidth,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Etiket içeriğini burada düzenleyin
                pw.Text(etikett.name, style: pw.TextStyle(fontSize: 20)),
                pw.Text(etikett.description, style: pw.TextStyle(fontSize: 16)),
                pw.Text('Layoutrechts: ${etikett.layoutrechts}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text('Firma: ${etikett.firma}',
                    style: pw.TextStyle(fontSize: 16)),
                // Daha fazla içerik eklenebilir
              ],
            ),
          );
        },
      ));
    }

    Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        usePrinterSettings: true,
        format: customPageFormat,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'firma': firma,
      'layoutrechts': layoutrechts,
    };
  }

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
