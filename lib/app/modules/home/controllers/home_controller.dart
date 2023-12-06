import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';

class HomeController extends GetxController {
  var depo = GetStorage();
  var produkte = <Etikett>[].obs;
  var counter = 0.obs;

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController layoutrechts = TextEditingController();
  TextEditingController quantity = TextEditingController();

  TextEditingController firmaController = TextEditingController();
  TextEditingController firmaAdresseController = TextEditingController();
  TextEditingController bottomlayout1Controller = TextEditingController();
  TextEditingController bottomlayout2Controller = TextEditingController();
  TextEditingController ipAdressController = TextEditingController();
  TextEditingController portController = TextEditingController();
  var firma = ''.obs;
  var firmaAdresse = ''.obs;
  var bottomlayout1 = ''.obs;
  var bottomlayout2 = ''.obs;

  String fontSizeTitel = '34,17';
  String fontSizeDescription = '26,14';
  String fontSizeLayout = '26,13';

  var ipAdress = "".obs;
  var port = 9100.obs;

  void getDatas() {
    depo.writeIfNull("firma", "");
    depo.writeIfNull("firmaAdresse", "");
    depo.writeIfNull("bottomlayout1 ", "");
    depo.writeIfNull("bottomlayout2 ", "");
    firma.value = depo.read("firma");
    firmaAdresse.value = depo.read("firmaAdresse");
    bottomlayout1.value = depo.read("bottomlayout1");
    bottomlayout2.value = depo.read("bottomlayout2");
    firmaController.text = firma.value;
    firmaAdresseController.text = firmaAdresse.value;
    bottomlayout1Controller.text = bottomlayout1.value;
    bottomlayout2Controller.text = bottomlayout2.value;
    depo.writeIfNull("ipAdress", "192.168.xxx.xxx");
    depo.writeIfNull("port", 9100);

    ipAdress.value = depo.read("ipAdress");
    print("IP ADRESS: " + ipAdress.value.toString());
    print("PORT: " + port.value.toString());
    port.value = depo.read("port");
    ipAdressController.text = ipAdress.value;
    portController.text = port.value.toString();

    update();
  }

  void searchProdukt(String search) {
    produkte.clear();
    var get = depo.read('produkte');
    if (get != null) {
      produkte.addAll((get as List).map((e) => Etikett.fromJson(e)).toList());
    }
    produkte = produkte
        .where((element) =>
            element.name.toLowerCase().contains(search.toLowerCase()))
        .toList()
        .obs;
    update();
  }

  void setDatas(String comefirma, String comeFirmaAdresse,
      String comeBottomlayout1, String comeBottomlayout2) {
    depo.write("firma", comefirma);
    depo.write("firmaAdresse", comeFirmaAdresse);
    depo.write("bottomlayout1", comeBottomlayout1);
    depo.write("bottomlayout2", comeBottomlayout2);
    update();
  }

  void setIPAdress(String comeIPAdress, int comePort) {
    depo.write("ipAdress", comeIPAdress);
    depo.write("port", comePort);

    update();
  }

  void printCounter(int count) {
    depo.write("counter", count);
    update();
  }

  void addProdukt(Etikett etikett) {
    produkte.add(etikett);
    depo.write('produkte', produkte.map((e) => e.toJson()).toList());
    Get.back();
    name.clear();
    description.clear();
    layoutrechts.clear();
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

  void printx(int id, int quantity) async {
    depo.write("counter", counter.value += quantity);
    Get.back();
    var etikett = produkte.firstWhere((element) => element.id == id);

    print("Etiket name: " + etikett.name.length.toString());
    print("ETIKET DESC:" + etikett.description.length.toString());
    print("ETIKET LAYOUTR:" + etikett.layoutrechts.length.toString());

    String label = '';

    if (etikett.name.length > 26) {
      fontSizeTitel = '28,14';
    } else if (etikett.name.length <= 25) {
      fontSizeTitel = '40,20';
    } else if (etikett.name.length > 35) {
      fontSizeTitel = ' 22,11';
    } else if (etikett.name.length > 40) {
      fontSizeTitel = '20,10';
    } else if (etikett.name.length > 50) {
      fontSizeTitel = '18,9';
    } else if (etikett.name.length > 60) {
      Get.snackbar("Error", "Maximal 60 Chracter erlaubt,Bitte kürzen Sie es");
    }

    if (etikett.description.length < 450) {
      fontSizeDescription = '28,14';
    } else if (etikett.description.length >= 450) {
      fontSizeDescription = '26,13';
    } else if (etikett.description.length > 600) {
      fontSizeDescription = '24,12';
    } else if (etikett.description.length > 700) {
      fontSizeDescription = '22,11';
    } else if (etikett.description.length > 800) {
      fontSizeDescription = '20,10';
    } else if (etikett.description.length > 900) {
      Get.snackbar("Error", "Maximal 900 Chracter erlaubt,Bitte kürzen Sie es");
    }

    if (etikett.layoutrechts.length < 200) {
      fontSizeLayout = '28,14';
    } else if (etikett.layoutrechts.length >= 200) {
      fontSizeLayout = '26,13';
    } else if (etikett.layoutrechts.length > 300) {
      fontSizeLayout = '24,12';
    } else if (etikett.layoutrechts.length > 400) {
      fontSizeLayout = '22,11';
    } else if (etikett.layoutrechts.length > 500) {
      fontSizeLayout = '20,10';
    } else if (etikett.layoutrechts.length > 900) {
      Get.snackbar("Error", "Maximal 900 Chracter erlaubt,Bitte kürzen Sie es");
    }

    label += '^CI28'; // UTF-8 karakter setine geçiş için SBPL komutu

// Etiket boyutunu ayarlama komutları
    label += '^XA'; // Etiket başlangıcı
    label += '^LL0588'; // Etiket uzunluğu yaklaşık 588 nokta (yaklaşık 4.9 cm)
    label += '^PW0888'; // Etiket genişliği yaklaşık 888 nokta (yaklaşık 7.4 cm)

// Başlık için 1 mm yukarıda boşluk bırakarak ve fontu %20 daha büyük yapma
    label +=
        '^FO12,12^ADN,$fontSizeTitel^FD ${etikett.name}^FS'; // ETIKET Baslik, 12 nokta yukarıda başlayarak

    int dividerStart =
        530; // Sol taraf genişliği, etiket genişliğinin yaklaşık %60'ı
    int headerHeight = 50; // Başlık yüksekliği ve 1 mm boşluk dahil

// Sol taraf için metin yazdırma, başlığın altından ve 1 mm boşluk bırakarak
    label +=
        '^FO12,${headerHeight + 24}^ADN,$fontSizeDescription^FB518,25,,^FD ${etikett.description}^FS'; // ETIKET Açıklama, 25 satıra kadar, %20 daha büyük font

// Sağ taraf için metin alanını genişletme, başlığın altından ve 1 mm boşluk bırakarak
    label +=
        '^FO${dividerStart + 14},${headerHeight + 12}^ADN,$fontSizeLayout^FB346,25,,^FD ${etikett.layoutrechts}^FS'; // ACIKLAMA, 25 satıra kadar, %20 daha büyük font

// Alt metinler, 1 mm boşluk bırakarak
    int bottomTextStart =
        512; // Alt metinlerin başlangıç noktası, 12 nokta aşağıda
    label += '^FO12,$bottomTextStart^ADN,24,12^FD$firma^FS';
    label += '^FO12,${bottomTextStart + 20}^ADN,20,10^FD$firmaAdresse^FS';
    label += '^FO12,${bottomTextStart + 40}^ADN,20,10^FD$bottomlayout1^FS';
    label += '^FO12,${bottomTextStart + 60}^ADN,20,10^FD$bottomlayout2^FS';
//Importiert von: International Traiding EAD GmbH, Alter Teichweg 11-13 22081 Hamburg
//Hinweise: Kühl und trocken Lagern, vor Wärme schützen
//Mindestens haltbar bis: Siehe Verpackung
// Etiket sonu
    label += '^XZ';

    // TCP soketi oluştur ve yazıcıya bağlan
    var socket = await Socket.connect(ipAdress.value, port.value);
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
    depo.writeIfNull("counter", 0);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await getProdukte();
    getDatas();
    update();
    print(produkte.length);
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
