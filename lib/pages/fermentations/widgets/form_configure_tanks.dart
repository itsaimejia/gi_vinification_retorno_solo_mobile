// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/tank_model.dart';
import 'package:gi_vinification_retorno/models/wine_model.dart';
import 'package:gi_vinification_retorno/services/tank_services.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';
import 'package:gi_vinification_retorno/widgets/widgets_forms.dart';

class FormConfigureTank extends StatefulWidget {
  final TankServices tankServices;
  final List<String> nameVarietals;
  const FormConfigureTank(
      {Key? key, required this.tankServices, required this.nameVarietals})
      : super(key: key);

  @override
  State<FormConfigureTank> createState() => _FormConfigureTankState();
}

class _FormConfigureTankState extends State<FormConfigureTank> {
  List<TextEditingController> controllersPercentage = [];
  List<TextEditingController> controllersVarietal = [];
  List<String> listTanksName = [];
  List<String?>? varietalValues = [null, null, null, null];
  List<BlemTank> listBlem = [];
  List<String> verifyVarietals = [];
  String? wineTypeValue;
  String? tankValue;
  String previousValue = '';
  String errorMessage = '';
  String brothOrMixture = '';
  bool errorSaveData = false;
  bool enableToAdd = false;
  bool enableToEditData = false;
  bool brothChecked = false;
  bool mixtureChecked = false;
  bool enableToSelect = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (listTanksName.isEmpty) {
      try {
        widget.tankServices.getList();
        setState(() {
          for (var element in widget.tankServices.listData) {
            if (element.blem.isEmpty) {
              listTanksName.add(element.tankId!);
            }
          }
        });
      } catch (e) {}
    }
    super.initState();
  }

  onSave() async {
    if (_formKey.currentState!.validate()) {
      try {
        verifyVarietals.clear();
        listBlem.clear();
        final tankName = tankValue;
        final wineType = wineTypeValue;
        for (var i = 0; i < controllersPercentage.length; i++) {
          listBlem.add(BlemTank(
              percentage: int.parse(controllersPercentage[i].value.text),
              varietal: controllersVarietal[i].value.text));
        }
        final sum =
            listBlem.map((e) => e.percentage).toList().reduce((a, b) => a + b);

        bool errorSum = sum != 100;
        bool errorVarietals = false;
        for (var i = 0; i < controllersVarietal.length; i++) {
          if (!verifyVarietals.contains(controllersVarietal[i].value.text)) {
            verifyVarietals.add(controllersVarietal[i].value.text);
            errorVarietals = false;
          } else {
            errorVarietals = true;
            break;
          }
        }
        setState(() {
          errorMessage = errorSum
              ? 'Las suma de los porcentajes debe ser igual a 100'
              : errorVarietals
                  ? 'No puedes usar 2 veces el mismo varietal'
                  : '';
        });
        if (!errorSum && !errorVarietals) {
          String blem =
              listBlem.toString().replaceAll('[', '').replaceAll(']', '');
          bool responseTank = await widget.tankServices.update(Tank(
              brothOrMixture: brothOrMixture,
              blem: blem
                  .split(',')
                  .map((x) => x.split('-'))
                  .map((w) => '${w[0]}-${w[1]}')
                  .join(','),
              liters: 0,
              wineType: wineType!,
              tankId: tankName));
          if (responseTank) {
            Navigator.pop(context, true);
          } else {
            errorSaveData = true;
            setState(() {});
          }
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: 520,
          width: 400,
          child: Column(
            children: [
              Text(
                'Error al guardar el registro',
                style: TextStyle(
                    color: errorSaveData ? Colors.red : Colors.transparent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckBoxCustom(
                      enable: listTanksName.isNotEmpty,
                      label: 'Caldo',
                      value: brothChecked,
                      onChanged: (value) {
                        setState(() {
                          brothChecked = value!;
                          mixtureChecked = !value;
                          brothOrMixture = 'broth';
                          enableToSelect = true;
                          tankValue = null;
                          controllersPercentage.clear();
                          controllersVarietal.clear();
                          enableToAdd = false;
                          enableToEditData = false;
                        });
                        addNewLine();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CheckBoxCustom(
                      enable: listTanksName.isNotEmpty,
                      label: 'Mezcla',
                      value: mixtureChecked,
                      onChanged: (value) {
                        setState(() {
                          mixtureChecked = value!;
                          brothChecked = !value;
                          brothOrMixture = 'mixture';
                          enableToSelect = true;
                          tankValue = null;
                          controllersPercentage.clear();
                          controllersVarietal.clear();
                          enableToAdd = false;
                          enableToEditData = false;
                        });
                        addNewLine();
                        addNewLine();
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
                            varietalValues = [null, null, null, null];
                            tankValue = value;
                            wineTypeValue = null;
                            enableToAdd = true;
                            enableToEditData = true;
                          });
                        },
                        hintText: 'Tanque',
                        value: tankValue,
                        items: listTanksName),
                  ),
                  Expanded(
                    flex: 2,
                    child: Tooltip(
                      message: 'Tipo de vino',
                      child: DropdownButtonForm(
                          enabled: enableToEditData,
                          validator: ((value) {
                            if (wineTypeValue == null) {
                              return 'Selecciona un tipo';
                            }
                            return null;
                          }),
                          onChanged: (String? value) =>
                              setState(() => wineTypeValue = value),
                          hintText: 'Tipo de vino',
                          value: wineTypeValue,
                          items: Wine.types),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Blem'),
                        const Spacer(),
                        if (mixtureChecked)
                          IconButton(
                              onPressed: enableToAdd &&
                                      mixtureChecked &&
                                      controllersPercentage.length > 2
                                  ? deleteLine
                                  : null,
                              icon: const Icon(Icons.remove)),
                        if (mixtureChecked)
                          IconButton(
                              onPressed: enableToAdd &&
                                      mixtureChecked &&
                                      controllersPercentage.length < 4
                                  ? addNewLine
                                  : null,
                              icon: const Icon(Icons.add)),
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
                          itemCount: controllersPercentage.length,
                          itemBuilder: ((context, index) {
                            return Tooltip(
                              message: 'Configurar Blem',
                              child: Container(
                                color: index % 2 == 0
                                    ? Colors.white
                                    : Colors.grey.shade200,
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: DropdownButtonForm(
                                            enabled: enableToEditData,
                                            validator: ((value) {
                                              if (varietalValues![index] ==
                                                  null) {
                                                return 'Selecciona un varietal';
                                              }
                                              return null;
                                            }),
                                            onChanged: (String? value) {
                                              controllersVarietal[index].text =
                                                  value!;
                                              varietalValues![index] = value;
                                              setState(() {});
                                            },
                                            hintText: enableToEditData
                                                ? 'Varietal'
                                                : 'Primero selecciona tanque',
                                            value: varietalValues![index],
                                            items: widget.nameVarietals)),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: DataInput(
                                        enabled:
                                            mixtureChecked && enableToEditData,
                                        labelText: 'Porcentaje',
                                        controller:
                                            controllersPercentage[index],
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Ingresa el porcentaje';
                                          } else if (!value.isAIntNumber) {
                                            return 'Enteros';
                                          } else if (double.parse(value) <= 0) {
                                            return 'El valor debe ser mayor a 0';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                    ),
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(
                        color: errorMessage.isNotEmpty
                            ? Colors.red
                            : Colors.transparent,
                        fontSize: 12),
                  )
                ],
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

  addNewLine() {
    if (controllersPercentage.length < 4) {
      setState(() {
        controllersVarietal.add(TextEditingController());
        controllersPercentage
            .add(TextEditingController(text: brothChecked ? '100' : ''));
      });
    }
  }

  deleteLine() {
    if (controllersPercentage.length > 2) {
      setState(() {
        controllersVarietal.removeLast();
        controllersPercentage.removeLast();
      });
    }
  }
}
