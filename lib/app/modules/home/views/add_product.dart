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
            child: Column(
          children: [
            TextFormField(
              controller: controller.name,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextFormField(
              controller: controller.description,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextFormField(
              controller: controller.layoutrechts,
              decoration: const InputDecoration(
                labelText: 'Layoutrechts',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.addProdukt(Etikett(
                    id: 1,
                    name: controller.name.text,
                    description: controller.description.text,
                    firma: controller.firma.value,
                    layoutrechts: 'Layoutrechts'));
              },
              child: const Text('Add'),
            ),
          ],
        )));
  }
}
