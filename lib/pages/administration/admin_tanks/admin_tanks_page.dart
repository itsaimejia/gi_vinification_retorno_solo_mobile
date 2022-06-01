// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/tank_model.dart';
import 'package:gi_vinification_retorno/services/tank_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';
import 'package:gi_vinification_retorno/widgets/widgets_forms.dart';
import 'package:provider/provider.dart';

class AdminTanksPage extends StatefulWidget {
  const AdminTanksPage({Key? key}) : super(key: key);

  @override
  State<AdminTanksPage> createState() => _AdminTanksPageState();
}

class _AdminTanksPageState extends State<AdminTanksPage> {
  List<Tank> listTanks = [];
  final tankController = TextEditingController();
  final tankConfirmController = TextEditingController();
  late TankServices tankServices;
  bool errorTankExist = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    var mediaHeight = MediaQuery.of(context).size.height;
    tankServices = Provider.of<TankServices>(context);
    if (listTanks.isEmpty) {
      try {
        setState(() {
          tankServices.getList();
          listTanks = tankServices.listData;
        });
      } catch (e) {}
    }
    if (tankServices.loadData) {
      return Container(
        alignment: Alignment.center,
        color: backgroundColor,
        child: const CircularProgressIndicator(),
      );
    } else {
      return Container(
        alignment: mediaWidth > 820 ? Alignment.center : Alignment.topCenter,
        child: Material(
            color: backgroundColor,
            elevation: 3,
            borderRadius: BorderRadius.circular(12),
            child: Form(
              key: _formKey,
              child: Container(
                height: mediaWidth > 820 ? 700 : mediaHeight - 250,
                width: mediaWidth > 820 ? 500 : double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: secundaryColor, width: 1)),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Row(
                              children: [
                                const Text(
                                  'Administrar tanques',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: reloadData,
                                  child: const Icon(Icons.refresh),
                                )
                              ],
                            )),
                      ],
                    ),
                    TableRow(children: [
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Tooltip(
                              preferBelow: true,
                              message: 'Nombre del tanque',
                              child: DataInput(
                                suffixIcon: Tooltip(
                                  message: 'Presiona para agregar',
                                  child: GestureDetector(
                                    onTap: onAdd,
                                    child: const Icon(
                                      Icons.add,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                icon: Icons.edit_note_rounded,
                                color: primaryColor,
                                labelText: 'Agregar tanque',
                                controller: tankController,
                                onEditingComplete:
                                    mediaWidth > 820 ? onAdd : null,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Campo vacío';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ))
                    ]),
                    TableRow(children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.only(bottom: 5),
                          width: 250,
                          height: 10,
                          child: Text(
                            'El tanque existe',
                            style: TextStyle(
                                color: errorTankExist
                                    ? Colors.red
                                    : Colors.transparent,
                                fontSize: 10),
                          ),
                        ),
                      )
                    ]),
                    TableRow(children: [
                      Center(
                        child: SizedBox(
                          height: mediaWidth > 820 ? 580 : mediaHeight - 370,
                          width: 250,
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: listTanks.length,
                            itemBuilder: (context, index) {
                              if (listTanks.isNotEmpty) {
                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  color: tankColor,
                                  child: ListTile(
                                    title: Text(
                                      listTanks[index].tankId!,
                                      style: const TextStyle(
                                          color: backgroundColor),
                                    ),
                                    subtitle: Text(
                                      '${listTanks[index].blem.isEmpty ? 'Sin blem' : 'Con blem'}\nLts: ${listTanks[index].liters}',
                                      style: const TextStyle(
                                          color: backgroundColor, fontSize: 12),
                                    ),
                                    trailing: PopupMenuButton(
                                        tooltip: 'Opciones',
                                        iconSize: 20,
                                        position: PopupMenuPosition.under,
                                        color: backgroundColor,
                                        icon: const Icon(
                                          Icons.miscellaneous_services_rounded,
                                          color: backgroundColor,
                                        ),
                                        itemBuilder: ((context) => [
                                              if (listTanks[index]
                                                      .blem
                                                      .isNotEmpty &&
                                                  listTanks[index].liters <= 0)
                                                PopupMenuItem(
                                                    height: 40,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        await showDialog(
                                                            context:
                                                                this.context,
                                                            builder: (__) =>
                                                                AlertDialog(
                                                                    title: const Text(
                                                                        'Eliminar blem'),
                                                                    content:
                                                                        SizedBox(
                                                                      height:
                                                                          120,
                                                                      child: Column(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Container(
                                                                                alignment: Alignment.center,
                                                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                                                margin: const EdgeInsets.only(left: 5, right: 5),
                                                                                color: Colors.red.shade200,
                                                                                child: Text.rich(TextSpan(children: [
                                                                                  TextSpan(
                                                                                    text: 'La siguiente acción elimina la configuración (Blem)\nEscribe ',
                                                                                    style: TextStyle(color: Colors.red.shade800),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: listTanks[index].tankId,
                                                                                    style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: ' y ',
                                                                                    style: TextStyle(color: Colors.red.shade800),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: 'Aceptar',
                                                                                    style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: ' para continuar',
                                                                                    style: TextStyle(color: Colors.red.shade800),
                                                                                  ),
                                                                                ])),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                                child: Container(
                                                                              alignment: Alignment.center,
                                                                              margin: const EdgeInsets.only(left: 5, right: 5),
                                                                              child: DataInput(
                                                                                controller: tankConfirmController,
                                                                                labelText: listTanks[index].tankId!,
                                                                              ),
                                                                            )),
                                                                          ]),
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        child:
                                                                            const Text(
                                                                          'Cancelar',
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          if (listTanks[index].tankId ==
                                                                              tankConfirmController.value.text.trim()) {
                                                                            await tankServices.update(Tank(
                                                                                blem: '',
                                                                                liters: 0,
                                                                                wineType: '',
                                                                                brothOrMixture: '',
                                                                                tankId: listTanks[index].tankId!));
                                                                            await reloadData();
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          }
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'Aceptar',
                                                                          style:
                                                                              TextStyle(color: Colors.red),
                                                                        ),
                                                                      ),
                                                                    ]));
                                                      },
                                                      child: const Text(
                                                        'Eliminar blem',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    )),
                                              if (listTanks[index]
                                                      .blem
                                                      .isEmpty &&
                                                  listTanks[index].liters <= 0)
                                                PopupMenuItem(
                                                    height: 40,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        await showDialog(
                                                            context:
                                                                this.context,
                                                            builder: (__) =>
                                                                AlertDialog(
                                                                    title: const Text(
                                                                        'Borrar varietal'),
                                                                    content:
                                                                        SizedBox(
                                                                      height:
                                                                          120,
                                                                      child: Column(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Container(
                                                                                alignment: Alignment.center,
                                                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                                                margin: const EdgeInsets.only(left: 5, right: 5),
                                                                                color: Colors.red.shade200,
                                                                                child: Text.rich(TextSpan(children: [
                                                                                  TextSpan(
                                                                                    text: 'La siguiente acción eliminará permanentemente el varietal\nEscribe ',
                                                                                    style: TextStyle(color: Colors.red.shade800),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: listTanks[index].tankId,
                                                                                    style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: ' y presiona ',
                                                                                    style: TextStyle(color: Colors.red.shade800),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: 'Aceptar',
                                                                                    style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: ' para continuar',
                                                                                    style: TextStyle(color: Colors.red.shade800),
                                                                                  ),
                                                                                ])),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                                child: Container(
                                                                              alignment: Alignment.center,
                                                                              margin: const EdgeInsets.only(left: 5, right: 5),
                                                                              child: DataInput(
                                                                                controller: tankConfirmController,
                                                                                labelText: listTanks[index].tankId!,
                                                                              ),
                                                                            )),
                                                                          ]),
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        child:
                                                                            const Text(
                                                                          'Cancelar',
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          if (listTanks[index].tankId ==
                                                                              tankConfirmController.value.text.trim()) {
                                                                            await tankServices.delete(listTanks[index].tankId!.toEncodeId());
                                                                            await reloadData();
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          }
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'Aceptar',
                                                                          style:
                                                                              TextStyle(color: Colors.red),
                                                                        ),
                                                                      ),
                                                                    ]));
                                                      },
                                                      child: const Text(
                                                        'Eliminar',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ))
                                            ])),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                      )
                    ])
                  ],
                ),
              ),
            )),
      );
    }
  }

  void onAdd() async {
    setState(() {
      errorTankExist = false;
    });
    if (_formKey.currentState!.validate()) {
      final name = tankController.value.text.trim();
      final response = await tankServices.get(name);
      if (response == null) {
        final varietal = Tank(
          brothOrMixture: '',
          tankId: name,
          blem: '',
          liters: 0,
          wineType: '',
        );
        await tankServices.add(varietal);
        reloadData();
        tankController.clear();
      } else {
        setState(() {
          errorTankExist = true;
        });
      }
    }
  }

  Future<void> reloadData() async {
    listTanks.clear();
    await tankServices.getList();
    setState(() {
      listTanks = tankServices.listData;
    });
  }
}
