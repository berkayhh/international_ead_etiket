import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'dart:io';
import 'dart:convert';

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

/*   Future<void> printEtiket(int id, int quantity) async {
    Get.back();
    var etikett = produkte.firstWhere((element) => element.id == id);

    // 3.5x2 inç boyutunu tanımla (piksel cinsinden dönüşüm: 1 inç = 72 piksel)
    //Etiket Büyüklügü 4.9x7.4 cm

    final pdf = pw.Document();

    // Özel etiket boyutlarını tanımlayın
    const PdfPageFormat labelFormat = PdfPageFormat(
      7.4 * PdfPageFormat.cm, // genişlik 7.4 cm
      4.9 * PdfPageFormat.cm, // yükseklik 4.9 cm
      marginTop: 0,
      marginLeft: 0,
      marginRight: 0,
      marginBottom: 0,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: labelFormat,
        build: (pw.Context context) {
          return pw.Container(
            child: pw.Stack(
              children: [
                // Sol Üst Köşe
                pw.Positioned(
                  left: 0,
                  top: 0,
                  child: pw.Text('1', style: pw.TextStyle(fontSize: 12)),
                ),
                // Sağ Üst Köşe
                pw.Positioned(
                  right: 0,
                  top: 0,
                  child: pw.Text('2', style: pw.TextStyle(fontSize: 12)),
                ),
                // Sol Alt Köşe
                pw.Positioned(
                  left: 0,
                  bottom: 0,
                  child: pw.Text('3', style: pw.TextStyle(fontSize: 12)),
                ),
                // Sağ Alt Köşe
                pw.Positioned(
                  right: 0,
                  bottom: 0,
                  child: pw.Text('4', style: pw.TextStyle(fontSize: 12)),
                ),
              ],
            ),
          );
        },
      ),
    );

    // PDF'i kaydedebilir veya yazdırabilirsiniz.
    // Örneğin, cihazda bir dosya olarak kaydetmek için:

    // Yazdırmak için:
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  } */
  void printx(int id, int quantity) async {
    Get.back();
    var etikett = produkte.firstWhere((element) => element.id == id);
    String label = '';

    label += '^CI28'; // UTF-8 karakter setine geçiş için SBPL komutu

// Etiket boyutunu ayarlama komutları
    label += '^XA'; // Etiket başlangıcı
    label += '^LL0588'; // Etiket uzunluğu yaklaşık 588 nokta (yaklaşık 4.9 cm)
    label += '^PW0888'; // Etiket genişliği yaklaşık 888 nokta (yaklaşık 7.4 cm)

// Başlık için 1 mm yukarıda boşluk bırakarak ve fontu %20 küçültme
    label +=
        '^FO12,12^ADN,28,14^FD ${etikett.name}^FS'; // ETIKET Baslik, 12 nokta yukarıda başlayarak

    int dividerStart =
        530; // Sol taraf genişliği, etiket genişliğinin yaklaşık %60'ı
    int headerHeight = 42; // Başlık yüksekliği ve 1 mm boşluk dahil

// Sol taraf için metin yazdırma, başlığın altından ve 1 mm boşluk bırakarak
    label +=
        '^FO12,${headerHeight + 24}^ADN,26,14^FB518,25,,^FD ${etikett.description}^FS'; // ETIKET Açıklama, 25 satıra kadar

// Sağ taraf için metin alanını genişletme, başlığın altından ve 1 mm boşluk bırakarak
    label +=
        '^FO${dividerStart + 14},${headerHeight + 12}^ADN,26,14^FB346,25,,^FD ${etikett.layoutrechts}^FS'; // ACIKLAMA, 25 satıra kadar

// Alt metinler, 1 mm boşluk bırakarak
    int bottomTextStart =
        512; // Alt metinlerin başlangıç noktası, 12 nokta aşağıda
    label +=
        '^FO12,${bottomTextStart}^ADN,18,10^FDImportiert von: International Traiding EAD GmbH, Alter Teichweg 11-13^FS';
    label += '^FO12,${bottomTextStart + 20}^ADN,18,10^FD22081 Hamburg^FS';
    label +=
        '^FO12,${bottomTextStart + 40}^ADN,18,10^FDHinweise: Kühl und trocken Lagern, vor Wärme schützen^FS';
    label +=
        '^FO12,${bottomTextStart + 60}^ADN,18,10^FDMindestens haltbar bis: Siehe Verpackung^FS';

// Etiket sonu
    label += '^XZ';

    // Yazıcı IP adresi ve portu
    var host = '192.168.150.91';
    var port = 9100; // Genellikle 9100

    // TCP soketi oluştur ve yazıcıya bağlan
    var socket = await Socket.connect(host, port);
    print('Printer Connected');

    // Etiketi yazdır
    for (int i = 0; i < quantity; i++) {
      socket.write(label);
      await socket.flush();
    }

    // Bağlantıyı kapat
    socket.close();
    print('Printer Disconnected');
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
