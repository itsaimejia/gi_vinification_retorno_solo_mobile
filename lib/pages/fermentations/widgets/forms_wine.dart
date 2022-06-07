// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/globals.dart';
import 'package:gi_vinification_retorno/models/tank_model.dart';
import 'package:gi_vinification_retorno/models/varietal_model.dart';
import 'package:gi_vinification_retorno/models/wine_model.dart';
import 'package:gi_vinification_retorno/services/tank_services.dart';
import 'package:gi_vinification_retorno/services/varietal_services.dart';
import 'package:gi_vinification_retorno/services/wine_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';
import 'package:gi_vinification_retorno/widgets/widgets_forms.dart';

class FormAddWine extends StatefulWidget {
  final String id;
  final String date;
  final WineServices wineServices;
  final TankServices tankServices;
  final VarietalServices varietalServices;
  final List<String> nameVarietals;
  const FormAddWine(
      {Key? key,
      required this.id,
      required this.date,
      required this.wineServices,
      required this.tankServices,
      required this.varietalServices,
      required this.nameVarietals})
      : super(key: key);

  @override
  State<FormAddWine> createState() => _FormAddWineState();
}

class _FormAddWineState extends State<FormAddWine> {
  final anadaController = TextEditingController();
  final ranchController = TextEditingController();
  final wineTypeController = TextEditingController();
  final observationsController = TextEditingController();
  final litersController = TextEditingController();
  late List<TextEditingController> controllersPercentage = [];
  late List<TextEditingController> controllersQuantityUsed = [];
  late List<TextEditingController> controllersVarietal = [];
  late List<TextEditingController> controllersTankUsed = [];
  List<String?>? tankNameUsedValues = [null, null, null, null];
  List<List<String>> listBrothTanksToUse = [];
  List<String> listTankNameBroth = [];
  List<String> listTankNameMixture = [];
  String blemTank = '';
  String? tankValue;
  bool enableToWrite = false;
  bool errorSaveData = false;
  bool brothChecked = false;
  bool mixtureChecked = false;
  bool enableToSelect = false;
  late double mediaWidth;

  @override
  void initState() {
    widget.tankServices.getList();
    for (var tank in widget.tankServices.listData) {
      if (tank.blem.isNotEmpty) {
        if (tank.brothOrMixture == 'broth') {
          listTankNameBroth.add(tank.tankId!);
        } else if (tank.brothOrMixture == 'mixture') {
          listTankNameMixture.add(tank.tankId!);
        }
      }
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  onSave() async {
    if (_formKey.currentState!.validate()) {
      try {
        final anada = anadaController.value.text.trim();
        final observations = observationsController.value.text.trim();
        final ranch = ranchController.value.text.trim().toCapitalizedEachOne();
        final tankName = tankValue;
        final wineType = wineTypeController.value.text;
        final liters = double.parse(litersController.value.text);

        if (brothChecked) {
          final blemBroth = BlemWine(
              quantityUsed: double.parse(controllersQuantityUsed[0].value.text),
              percentage: int.parse(controllersPercentage[0].value.text),
              varietal: controllersVarietal[0].value.text);
          bool responseWine = await widget.wineServices.add(Wine(
            responsible: Globals.getCompleteName(),
            blem: blemBroth.toString(),
            id: widget.id,
            date: widget.date,
            anada: anada,
            ranch: ranch,
            tankName: tankName!,
            type: wineType,
            liters: liters,
            observations: observations,
          ));
          Tank currentTank = await widget.tankServices.get(tankName);
          double newLiters = currentTank.liters + liters;
          bool responseTank = await widget.tankServices.update(Tank(
              brothOrMixture: currentTank.brothOrMixture,
              blem: currentTank.blem,
              liters: newLiters,
              wineType: currentTank.wineType,
              tankId: currentTank.tankId));
          Varietal updateVarietal =
              await widget.varietalServices.get(blemBroth.varietal);
          double newKilosUsed =
              updateVarietal.kilosUsed + blemBroth.quantityUsed;
          double newKilosReceived = updateVarietal.kilosReceived + 0;
          bool responseVarietal = await widget.varietalServices.update(Varietal(
              varietalId: blemBroth.varietal,
              kilosUsed: newKilosUsed,
              kilosReceived: newKilosReceived));
          if (responseWine && responseTank && responseVarietal) {
            Navigator.pop(context, true);
          } else {
            setState(() {
              errorSaveData = true;
            });
          }
        } else {
          List<BlemWine> listBlem = [];
          for (var i = 0; i < controllersPercentage.length; i++) {
            listBlem.add(BlemWine(
                percentage: int.parse(controllersPercentage[i].value.text),
                varietal: controllersVarietal[i].value.text,
                tankUsed: controllersTankUsed[i].value.text,
                quantityUsed:
                    double.parse(controllersQuantityUsed[i].value.text)));
          }

          String blemMixture = listBlem
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')
              .toString();
          bool responseWine = await widget.wineServices.add(Wine(
            responsible: Globals.getCompleteName(),
            blem: blemMixture,
            id: widget.id,
            date: widget.date,
            anada: anada,
            ranch: ranch,
            tankName: tankName!,
            type: wineType,
            liters: liters,
            observations: observations,
          ));
          Tank currentTank = await widget.tankServices.get(tankName);
          double newLiters = currentTank.liters + liters;
          bool responseTank = await widget.tankServices.update(Tank(
              brothOrMixture: currentTank.brothOrMixture,
              blem: currentTank.blem,
              liters: newLiters,
              wineType: currentTank.wineType,
              tankId: currentTank.tankId));
          List<bool> listResponseTank = [];
          for (var i = 0; i < controllersQuantityUsed.length; i++) {
            Tank getTank = await widget.tankServices.get(listBlem[i].tankUsed!);
            double newLiters = getTank.liters - listBlem[i].quantityUsed;
            listResponseTank.add(await widget.tankServices.update(Tank(
                brothOrMixture: getTank.brothOrMixture,
                blem: getTank.blem,
                liters: newLiters,
                wineType: getTank.wineType,
                tankId: getTank.tankId)));
          }

          bool resultResponseTanks = listResponseTank.reduce((a, b) => a == b);
          if (responseWine && responseTank && resultResponseTanks) {
            Navigator.pop(context, true);
          } else {
            setState(() {
              errorSaveData = true;
            });
          }
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: SizedBox(
          width: 465,
          child: Column(
            children: [
              Text(
                'Error al guardar el registro',
                style: TextStyle(
                    color: errorSaveData ? Colors.red : Colors.transparent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                color: Colors.red.shade100,
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'En caso de no estar el blem adecuado en el listado de tanques, configura un nuevo tanque en el botón',
                      style: TextStyle(fontSize: 13, color: tankColor),
                    ),
                    Row(
                      children: const [
                        Text('[',
                            style: TextStyle(fontSize: 13, color: tankColor)),
                        Icon(
                          Icons.settings,
                          size: 13,
                          color: tankColor,
                        ),
                        Text(' Configurar tanque',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: tankColor)),
                        Text(']',
                            style: TextStyle(fontSize: 13, color: tankColor)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'ID: ${widget.id}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckBoxCustom(
                      enable: listTankNameBroth.isNotEmpty,
                      label: 'Caldo',
                      value: brothChecked,
                      onChanged: (value) {
                        setState(() {
                          brothChecked = value!;
                          mixtureChecked = !value;
                          enableToSelect = true;
                          wineTypeController.clear();
                          controllersPercentage.clear();
                          controllersQuantityUsed.clear();
                          controllersVarietal.clear();
                          enableToWrite = false;
                          tankValue = null;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckBoxCustom(
                      enable: listTankNameBroth.isNotEmpty,
                      label: 'Mezcla',
                      value: mixtureChecked,
                      onChanged: (value) {
                        setState(() {
                          mixtureChecked = value!;
                          brothChecked = !value;
                          enableToSelect = true;
                          wineTypeController.clear();
                          controllersPercentage.clear();
                          controllersQuantityUsed.clear();
                          controllersVarietal.clear();
                          enableToWrite = false;
                          tankValue = null;
                        });
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonForm(
                        enabled: enableToSelect,
                        validator: ((value) {
                          if (tankValue == null) {
                            return 'Selecciona un tanque';
                          }
                          return null;
                        }),
                        onChanged: (String? value) async {
                          setState(() {
                            tankValue = value;
                            wineTypeController.clear();
                            controllersPercentage.clear();
                            controllersQuantityUsed.clear();
                            controllersVarietal.clear();
                            tankNameUsedValues = [null, null, null, null];
                            enableToWrite = true;
                          });
                          await fillBlemData(tankValue);
                        },
                        hintText: brothChecked
                            ? (listTankNameBroth.isNotEmpty
                                ? 'Tanque'
                                : 'Sin tanques de caldo configurados')
                            : mixtureChecked
                                ? (listTankNameMixture.isNotEmpty
                                    ? 'Tanque'
                                    : 'Sin tanques de mezcla configurados')
                                : 'Selecciona una opción',
                        value: tankValue,
                        items: brothChecked
                            ? listTankNameBroth
                            : mixtureChecked
                                ? listTankNameMixture
                                : []),
                  ),
                  Expanded(
                    flex: 1,
                    child: DataInput(
                      enabled: enableToWrite,
                      width: double.infinity,
                      labelText: 'Litros',
                      controller: litersController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa los litros';
                        } else if (!value.isANumber) {
                          return 'No se aceptan letras';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: DataInput(
                      enabled: false,
                      labelText: 'Tipo de vino',
                      controller: wineTypeController,
                    ),
                  ),
                  Expanded(
                    child: DataInput(
                      enabled: enableToWrite,
                      labelText: 'Rancho',
                      controller: ranchController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa el rancho';
                        } else if (!value.isAName) {
                          return 'No se aceptan números';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: DataInput(
                      enabled: enableToWrite,
                      width: double.infinity,
                      labelText: 'Añada',
                      controller: anadaController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa la añada';
                        } else if (value.isAWord) {
                          return 'Solo números';
                        } else if (value.length != 4) {
                          return 'Solo años validos';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: Row(
                      children: [
                        const Text('Blem'),
                        const Spacer(),
                        HelpTooltip(
                            message:
                                'Si se obtiene el caldo del mismo varietal de 2 o más tanques \nen la sección de Observaciones indica el nombre \nde los demás tanques usados (Ej. Tanque 3) para realizar los ajustes')
                      ],
                    ),
                  ),
                  Material(
                    elevation: 2,
                    child: SizedBox(
                      height: 280,
                      width: double.infinity,
                      child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: controllersVarietal.length,
                          itemBuilder: ((context, index) {
                            if (brothChecked) {
                              return buildBrothBlem(index);
                            } else if (mixtureChecked) {
                              return buildMixtureBlem(index);
                            } else {
                              return Container();
                            }
                          })),
                    ),
                  ),
                ],
              ),
              DataInput(
                enabled: enableToWrite,
                width: double.infinity,
                maxLines: 3,
                labelText: 'Observaciones',
                controller: observationsController,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: CancelButton(onPressed: () {
                      Navigator.pop(context);
                    }),
                  ),
                  Expanded(
                      child: SaveButton(
                    isDisabled: !enableToWrite,
                    onPressed: onSave,
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildMixtureBlem(int index) {
    return Container(
      color: index % 2 == 0 ? Colors.white : Colors.grey.shade200,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DataInput(
              enabled: false,
              labelText: 'Varietal',
              controller: controllersVarietal[index],
            ),
          ),
          Expanded(
            flex: 1,
            child: DataInput(
              enabled: false,
              labelText: '%',
              controller: controllersPercentage[index],
            ),
          ),
          Expanded(
              flex: 3,
              child: DropdownButtonForm(
                  enabled: listBrothTanksToUse[index].isNotEmpty,
                  validator: ((value) {
                    if (tankNameUsedValues![index] == null) {
                      return 'Selecciona un tanque';
                    }
                    return null;
                  }),
                  onChanged: (String? value) {
                    controllersTankUsed[index].text = value!;
                    tankNameUsedValues![index] = value;
                    setState(() {});
                  },
                  hintText: listBrothTanksToUse[index].isEmpty
                      ? 'No hay tanques'
                      : 'Tanque usado',
                  value: tankNameUsedValues![index],
                  items: listBrothTanksToUse[index])),
          Expanded(
            flex: 2,
            child: DataInput(
              labelText: mediaWidth > 820 ? 'Litros usados' : 'Lts.',
              controller: controllersQuantityUsed[index],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresa los litros usados';
                } else if (!value.isANumber) {
                  return 'Numeros';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Container buildBrothBlem(int index) {
    return Container(
      color: index % 2 == 0 ? Colors.white : Colors.grey.shade200,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DataInput(
              enabled: false,
              labelText: 'Varietal',
              controller: controllersVarietal[index],
            ),
          ),
          Expanded(
            flex: 2,
            child: DataInput(
              enabled: false,
              labelText: '%',
              controller: controllersPercentage[index],
            ),
          ),
          Expanded(
            flex: 2,
            child: DataInput(
              labelText: 'Kilos usados',
              controller: controllersQuantityUsed[index],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresa los kilos usados';
                } else if (!value.isANumber) {
                  return 'Numeros';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  addBrothLine({String? varietal, String? percentage}) {
    setState(() {
      controllersVarietal.add(TextEditingController(text: varietal));
      controllersPercentage.add(TextEditingController(text: percentage));
      controllersQuantityUsed.add(TextEditingController());
    });
  }

  addMixtureLine({String? varietal, String? percentage}) {
    setState(() {
      controllersVarietal.add(TextEditingController(text: varietal));
      controllersPercentage.add(TextEditingController(text: percentage));
      controllersTankUsed.add(TextEditingController());
      controllersQuantityUsed.add(TextEditingController());
    });
  }

  Future fillBlemData(String? tankName) async {
    try {
      final value = await widget.tankServices.get(tankName!);
      setState(() {
        enableToWrite = true;
        blemTank = value.blem;
        wineTypeController.text = value.wineType;
      });

      if (brothChecked) {
        final list = value.blem.split(',').map((v) => v.trim().split('-'));
        for (var l in list) {
          addBrothLine(varietal: l[0], percentage: l[1]);
        }
      } else if (mixtureChecked) {
        await widget.tankServices.getList();
        final list = value.blem.split(',').map((v) => v.trim().split('-'));
        for (var l in list) {
          List<String> listByBlem = [];
          for (var tank in widget.tankServices.listData) {
            if (tank.blem.isNotEmpty) {
              if (tank.brothOrMixture == 'broth' &&
                  tank.blem.split('-')[0].trim() == l[0].trim() &&
                  tank.liters > 0) {
                listByBlem.add(tank.tankId!);
              }
            }
          }
          setState(() {
            listBrothTanksToUse.add(listByBlem);
          });
          addMixtureLine(varietal: l[0], percentage: l[1]);
        }
      }
    } catch (e) {}
  }
}

class FormDeleteWine extends StatelessWidget {
  final Wine wine;
  final WineServices wineServices;
  final TankServices tankServices;
  final VarietalServices varietalServices;
  FormDeleteWine(
      {Key? key,
      required this.wine,
      required this.wineServices,
      required this.tankServices,
      required this.varietalServices})
      : super(key: key);
  final wineConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String blemText = wine.blem
        .split(',')
        .map((x) => x.trim().split('-'))
        .map((w) => '${w[0]} ${w[1]}%')
        .join('\n');

    onDelete() async {
      try {
        Tank getTank = await tankServices.get(wine.tankName);
        if (getTank.brothOrMixture == 'broth') {
          double newLiters = getTank.liters - wine.liters;
          bool responseTank = await tankServices.update(Tank(
              brothOrMixture: getTank.brothOrMixture,
              blem: getTank.blem,
              liters: newLiters,
              wineType: getTank.wineType,
              tankId: getTank.tankId));
          final blemFormat = wine.blem.split('-');
          final blemBroth = BlemWine(
              quantityUsed: double.parse(blemFormat[2]),
              percentage: int.parse(blemFormat[1]),
              varietal: blemFormat[0]);
          Varietal updateVarietal =
              await varietalServices.get(blemBroth.varietal);
          double newKilosUsed =
              updateVarietal.kilosUsed - blemBroth.quantityUsed;
          double newKilosReceived = updateVarietal.kilosReceived + 0;
          bool responseVarietal = await varietalServices.update(Varietal(
              varietalId: blemBroth.varietal,
              kilosUsed: newKilosUsed,
              kilosReceived: newKilosReceived));
          final responseWine = await wineServices.delete(wine.id!);
          if (responseWine && responseTank && responseVarietal) {
            Navigator.pop(context, true);
          }
        } else if (getTank.brothOrMixture == 'mixture') {
          double newLiters = getTank.liters - wine.liters;
          bool responseTank = await tankServices.update(Tank(
              brothOrMixture: getTank.brothOrMixture,
              blem: getTank.blem,
              liters: newLiters,
              wineType: getTank.wineType,
              tankId: getTank.tankId));
          List<bool> listResponseTank = [];
          final listBlemFormat = wine.blem.split(',');
          for (var i = 0; i < listBlemFormat.length; i++) {
            final currentBlemFormat =
                listBlemFormat[i].split('-').map((e) => e.trim()).toList();
            BlemWine currentBlem = BlemWine(
                quantityUsed: double.parse(currentBlemFormat[3]),
                percentage: int.parse(currentBlemFormat[1]),
                varietal: currentBlemFormat[0],
                tankUsed: currentBlemFormat[2]);
            Tank currentTank = await tankServices.get(currentBlem.tankUsed!);
            double newLiters = currentTank.liters + currentBlem.quantityUsed;
            listResponseTank.add(await tankServices.update(Tank(
                brothOrMixture: currentTank.brothOrMixture,
                blem: currentTank.blem,
                liters: newLiters,
                wineType: currentTank.wineType,
                tankId: currentTank.tankId)));
          }

          bool resultResponseTanks = listResponseTank.reduce((a, b) => a == b);
          final responseWine = await wineServices.delete(wine.id!);
          if (responseWine && responseTank && resultResponseTanks) {
            Navigator.pop(context, true);
          }
        }
      } catch (e) {}
    }

    return SizedBox(
      height: 500,
      width: 400,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 5, right: 5),
            margin: const EdgeInsets.only(left: 5, right: 5),
            color: Colors.red.shade200,
            child: Text.rich(TextSpan(children: [
              TextSpan(
                text:
                    'La siguiente acción elimina permanentemente el registro ',
                style: TextStyle(color: Colors.red.shade800),
              ),
              TextSpan(
                text: wine.id,
                style: TextStyle(
                    color: Colors.red.shade800, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' y también afecta a:\n',
                style: TextStyle(color: Colors.red.shade800),
              ),
              TextSpan(
                text:
                    '${wine.tankName}: -${wine.liters} lts.\n\nNota: Si es mezcla, regresa los listros usados a los tanques\nSi es caldo, regresa los kilos usados a los varietales\n',
                style: TextStyle(
                    color: Colors.red.shade800, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Escribe ',
                style: TextStyle(color: Colors.red.shade800),
              ),
              TextSpan(
                text: wine.id,
                style: TextStyle(
                    color: Colors.red.shade800, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' y ',
                style: TextStyle(color: Colors.red.shade800),
              ),
              TextSpan(
                text: 'Eliminar',
                style: TextStyle(
                    color: Colors.red.shade800, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' para continuar.',
                style: TextStyle(color: Colors.red.shade800),
              ),
            ])),
          ),
          LabelInfo(label: 'Tipo', value: wine.type),
          LabelInfo(label: 'Tanque', value: wine.tankName),
          LabelInfo(label: 'Blem', value: blemText),
          LabelInfo(label: 'Litros', value: wine.liters.toString()),
          LabelInfo(label: 'Añada', value: wine.anada),
          LabelInfo(label: 'Rancho', value: wine.ranch),
          DataInput(
            labelText: wine.id!,
            controller: wineConfirmController,
          ),
          Divider(
            height: 0.5,
            color: Colors.grey.shade200,
          ),
          const SizedBox(
            height: 15,
          ),
          DeleteButton(
              label: 'Eliminar',
              onPressed: () {
                if (wineConfirmController.value.text == wine.id) {
                  onDelete();
                }
              })
        ],
      ),
    );
  }
}
