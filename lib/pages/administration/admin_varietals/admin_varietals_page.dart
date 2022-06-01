// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/varietal_model.dart';
import 'package:gi_vinification_retorno/services/varietal_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';
import 'package:gi_vinification_retorno/widgets/widgets_forms.dart';
import 'package:provider/provider.dart';

class AdminVarietalsPage extends StatefulWidget {
  const AdminVarietalsPage({Key? key}) : super(key: key);

  @override
  State<AdminVarietalsPage> createState() => _AdminVarietalsPageState();
}

class _AdminVarietalsPageState extends State<AdminVarietalsPage> {
  List<Varietal> listVarietals = [];
  final varietalController = TextEditingController();
  final varietalConfirmController = TextEditingController();
  late VarietalServices varietalServices;
  bool errorVarietalExist = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    var mediaHeight = MediaQuery.of(context).size.height;
    varietalServices = Provider.of<VarietalServices>(context);
    if (listVarietals.isEmpty) {
      try {
        setState(() {
          varietalServices.getList();
          listVarietals = varietalServices.listData;
        });
      } catch (e) {}
    }
    if (varietalServices.loadData) {
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
                    const TableRow(
                      children: [
                        TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                              'Administrar varietales',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                              message: 'Nombre del varietal',
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
                                labelText: 'Agregar varietal',
                                controller: varietalController,
                                onEditingComplete:
                                    mediaWidth > 820 ? onAdd : null,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Campo vacío';
                                  } else if (!value.isAWord) {
                                    return 'No se aceptan números';
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
                            'El varietal existe',
                            style: TextStyle(
                                color: errorVarietalExist
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
                            itemCount: listVarietals.length,
                            itemBuilder: (context, index) {
                              if (listVarietals.isNotEmpty) {
                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  color: const Color(0xFF762677),
                                  child: ListTile(
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
                                              if (listVarietals[index]
                                                      .kilosReceived <=
                                                  0)
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
                                                                                    text: listVarietals[index].varietalId,
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
                                                                                controller: varietalConfirmController,
                                                                                labelText: listVarietals[index].varietalId!,
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
                                                                          if (listVarietals[index].varietalId ==
                                                                              varietalConfirmController.value.text.trim()) {
                                                                            await varietalServices.delete(listVarietals[index].varietalId!.toEncodeId());
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
                                    title: Text(
                                      listVarietals[index].varietalId!,
                                      style: const TextStyle(
                                          color: backgroundColor),
                                    ),
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
      errorVarietalExist = false;
    });
    if (_formKey.currentState!.validate()) {
      final name = varietalController.value.text.trim();
      final response = await varietalServices.get(name);
      if (response == null) {
        final varietal =
            Varietal(varietalId: name, kilosReceived: 0, kilosUsed: 0);
        await varietalServices.add(varietal);
        varietalController.clear();
        await reloadData();
      } else {
        setState(() {
          errorVarietalExist = true;
        });
      }
    }
  }

  Future<void> reloadData() async {
    listVarietals.clear();
    await varietalServices.getList();
    listVarietals = varietalServices.listData;
  }
}
