import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:international_ead_etiket/app/modules/home/views/add_product.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('International Trading EAD-Etiketten Drucker'),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Column(
          children: [
            /*          ElevatedButton(
                onPressed: () {
                  controller.printx();
                },
                child: Text("TEST")), */
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.produkte.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.produkte[index].id.toString() +
                          "-" +
                          controller.produkte[index].name),
                      subtitle: Text(controller.produkte[index].description),
                      onTap: () {
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
                                    description: controller.description.text,
                                    firma: controller.firma.value,
                                    layoutrechts: controller.layoutrechts.text,
                                  ));
                                },
                                child: const Text('Edit'),
                              ),
                            ],
                          ),
                        );
                      },
                      onLongPress: () {
                        Get.defaultDialog(
                          title: 'Delete',
                          content: Column(
                            children: [
                              Text(controller.produkte[index].id.toString() +
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
                        icon: const Icon(Icons.print),
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const AddProductView());
              },
              child: const Text('Add'),
            ),
          ],
        )));
  }
}
