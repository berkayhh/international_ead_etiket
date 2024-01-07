import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class AddProductView extends GetView<HomeController> {
  const AddProductView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
        appBar: AppBar(
          title: const Text('International Trading EAD-Add Productr'),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: controller.quillController,
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('de'),
                  ),
                ),
              ),
              Expanded(
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: controller.quillController,
                    readOnly: false,
                    sharedConfigurations: const QuillSharedConfigurations(
                      locale: Locale('de'),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    print(
                        controller.quillController.document.toDelta().toJson());
                  },
                  child: Text("Show Label Text")),
              TextFormField(
                controller: controller.name,
                decoration: const InputDecoration(
                  labelText: 'Produkt Name',
                ),
              ),
              TextFormField(
                controller: controller.description,
                decoration: const InputDecoration(
                  labelText: 'Beschriebung',
                ),
              ),
              TextFormField(
                controller: controller.layoutrechts,
                decoration: const InputDecoration(
                  labelText: 'Nährungswerte',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  int newId = controller.getUniqueProductId();
                  controller.addProdukt(Etikett(
                    id: newId,
                    name: controller.name.text,
                    description: controller.description.text,
                    firma: controller.firma.value,
                    layoutrechts: controller.layoutrechts.text,
                  ));
                },
                child: const Text('Add'),
              ),
            ],
          ),
        )));
  }
}
