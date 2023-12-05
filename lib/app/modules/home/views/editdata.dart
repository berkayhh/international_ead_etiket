import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class EditDataView extends GetView<HomeController> {
  const EditDataView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Daten Anpassen'),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                controller: controller.firmaController,
                decoration: const InputDecoration(
                  labelText: 'Firma',
                ),
              ),
              TextFormField(
                controller: controller.firmaAdresseController,
                decoration: const InputDecoration(
                  labelText: 'Firma Infos',
                ),
              ),
              TextFormField(
                controller: controller.bottomlayout1Controller,
                decoration: const InputDecoration(
                  labelText: 'Hinweis',
                ),
              ),
              TextFormField(
                controller: controller.bottomlayout2Controller,
                decoration: const InputDecoration(
                  labelText: 'MHD etc. Info',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.setDatas(
                    controller.firmaController.text,
                    controller.firmaAdresseController.text,
                    controller.bottomlayout1Controller.text,
                    controller.bottomlayout2Controller.text,
                  );
                  Get.offNamed('/home');
                },
                child: const Text('Update Daten'),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => Text("IP-Adresse: ${controller.ipAdress}")),
              Text("Port: ${controller.port.toString()}"),
              TextFormField(
                controller: controller.ipAdressController,
                decoration: const InputDecoration(
                  labelText: 'IP-Adresse',
                ),
              ),
              TextFormField(
                controller: controller.portController,
                decoration: const InputDecoration(
                  labelText: 'Port',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.ipAdressController.text.isNotEmpty &&
                      controller.portController.text.isNotEmpty) {
                    controller.setIPAdress(
                      controller.ipAdressController.text,
                      int.parse(controller.portController.text),
                    );
                    controller.getDatas();
                    controller.update();
                    Get.offNamed('/home');
                  } else {
                    Get.snackbar(
                        "Fehler", "Bitte IP-Adresse und Port eingeben");
                  }
                },
                child: const Text('Update Printer'),
              ),
            ],
          ),
        )));
  }
}
