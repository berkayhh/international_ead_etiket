import 'package:flutter/material.dart';
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
