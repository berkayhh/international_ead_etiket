

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
          Obx(() => Text(controller.counter.value.toString())),
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
        child: Column(
          children: [
            TextFormField(
              controller: controller.search,
              decoration: const InputDecoration(
                labelText: 'Produkt Suchen',
              ),
              onChanged: (value) {
                controller.searchProdukt(value);
              },
            ),
            Expanded(
              child: Obx(
                () => controller.produkte.isEmpty
                    ? Center(
                        child: Text(
                        "Keine Produkte vorhanden",
                        style: TextStyle(fontSize: Get.textScaleFactor * 30),
                      ))
                    : ListView.builder(
                        itemCount: controller.produkte.length,
                        itemBuilder: (context, index) {
                          if (controller.produkte.isEmpty) {
                            return const Center(
                              child: Text("Keine Produkte vorhanden"),
                            );
                          } else {
                            return Card(
                              child: ListTile(
                                title: Text(
                                    "${controller.produkte[index].id}-${controller.produkte[index].name}"),
                                subtitle: Text(
                                    controller.produkte[index].description),
                                onTap: () {
                                  Get.defaultDialog(
                                    //Ask how much the user need , quantity
                                    title:
                                        'Produkt:${controller.produkte[index].name}',
                                    content: Column(
                                      children: [
                                        TextFormField(
                                          controller: controller.quantity,
                                          decoration: const InputDecoration(
                                            labelText: 'Stückzahl',
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.printx(
                                                controller.produkte[index].id,
                                                int.parse(
                                                    controller.quantity.text));
                                          },
                                          child: const Text('Drucken'),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          color: Colors.grey[200],
                                          height: Get.height * 0.5,
                                          width: Get.width * 0.8,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Sol taraf
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${controller.produkte[index].name}',
                                                      style: const TextStyle(
                                                        fontSize:
                                                            20, // Başlık için büyük font boyutu
                                                        fontWeight: FontWeight
                                                            .bold, // Kalın
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      '${controller.produkte[index].description}',
                                                      style: const TextStyle(
                                                        fontSize:
                                                            14, // Açıklama için orta font boyutu
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Firma: ',
                                                        style: const TextStyle(
                                                          fontSize:
                                                              14, // Firma için orta font boyutu
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '${controller.firma}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // Diğer sol taraf içerikleri...
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Sağ taraf
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${controller.produkte[index].layoutrechts}',
                                                      style: const TextStyle(
                                                        fontSize:
                                                            14, // Sağ taraf metni için orta font boyutu
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    // Örnek ek içerikler
                                                    Text(
                                                      'Firma: ${controller.firma}',
                                                      style: const TextStyle(
                                                        fontSize:
                                                            12, // Firma için font boyutu
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Adresse: ${controller.firmaAdresse}',
                                                      style: const TextStyle(
                                                        fontSize:
                                                            12, // Adres için font boyutu
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Layout: ${controller.bottomlayout1}',
                                                      style: const TextStyle(
                                                        fontSize:
                                                            12, // Layout için font boyutu
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Weitere Info: ${controller.bottomlayout2}',
                                                      style: const TextStyle(
                                                        fontSize:
                                                            12, // Diğer bilgiler için font boyutu
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
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
                                        Text(
                                            "${controller.produkte[index].id}-${controller.produkte[index].name}"),
                                        Text(controller
                                            .produkte[index].description),
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
                                    controller.etiketid.text = controller
                                        .produkte[index].id
                                        .toString();
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
                                            controller: controller.etiketid,
                                            decoration: const InputDecoration(
                                              labelText: 'ID',
                                            ),
                                          ),
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
                                                id: int.parse(
                                                    controller.etiketid.text),
                                                name: controller.name.text,
                                                description:
                                                    controller.description.text,
                                                firma: controller.firma.value,
                                                layoutrechts: controller
                                                    .layoutrechts.text,
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
          ],
        ),
      ),
    );
  }
}
