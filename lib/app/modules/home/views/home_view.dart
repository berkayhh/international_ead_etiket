import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:international_ead_etiket/app/modules/home/views/add_product.dart';
import 'package:international_ead_etiket/app/modules/home/views/editdata.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('International Trading EAD-Etiketten Drucker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => const AddProductView());
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(() => const EditDataView());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => controller.produkte.isEmpty
              ? Center(
                  child: Text(
                  "Keine Produkte vorhanden,bitte oben rechts auf + drücken",
                  style: TextStyle(fontSize: Get.textScaleFactor * 30),
                ))
              : ListView.builder(
                  itemCount: controller.produkte.length,
                  itemBuilder: (context, index) {
                    print(controller.produkte.length);
                    if (controller.produkte.length <= 0) {
                    } else {
                      return Card(
                        child: ListTile(
                          title: Text(
                              "${controller.produkte[index].id}-${controller.produkte[index].name}"),
                          subtitle:
                              Text(controller.produkte[index].description),
                          onTap: () {
                            Get.defaultDialog(
                              //Ask how much the user need , quantity
                              title: 'Quantity',
                              content: Column(
                                children: [
                                  TextFormField(
                                    controller: controller.quantity,
                                    decoration: const InputDecoration(
                                      labelText: 'Quantity',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.printx(
                                          controller.produkte[index].id,
                                          int.parse(controller.quantity.text));
                                    },
                                    child: const Text('Print'),
                                  )
                                ],
                              ),
                            );
                          },
                          onLongPress: () {
                            Get.defaultDialog(
                              title: 'Delete',
                              content: Column(
                                children: [
                                  Text(
                                      controller.produkte[index].id.toString() +
                                          "-" +
                                          controller.produkte[index].name),
                                  Text(controller.produkte[index].description),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.removeProdukt(
                                          controller.produkte[index]);
                                      Get.back();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          trailing: IconButton(
                            onPressed: () {
                              controller.name.text =
                                  controller.produkte[index].name;
                              controller.description.text =
                                  controller.produkte[index].description;
                              controller.layoutrechts.text =
                                  controller.produkte[index].layoutrechts;
                              Get.defaultDialog(
                                title: 'Edit',
                                content: Column(
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
                                        controller.editProduct(Etikett(
                                          id: controller.produkte[index].id,
                                          name: controller.name.text,
                                          description:
                                              controller.description.text,
                                          firma: controller.firma.value,
                                          layoutrechts:
                                              controller.layoutrechts.text,
                                        ));
                                      },
                                      child: const Text('Edit'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }
}
