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
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.produkte.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.produkte[index].name),
                      subtitle: Text(controller.produkte[index].description),
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
                                    controller.printEtiket(
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
