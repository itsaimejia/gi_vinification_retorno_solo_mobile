// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/globals.dart';
import 'package:gi_vinification_retorno/models/grape_reception_model.dart';
import 'package:gi_vinification_retorno/models/varietal_model.dart';
import 'package:gi_vinification_retorno/services/grape_reception_services.dart';
import 'package:gi_vinification_retorno/services/varietal_services.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';
import 'package:gi_vinification_retorno/widgets/widgets_forms.dart';

class FormAddGrapeReception extends StatefulWidget {
  final String id;
  final String date;

  final GrapeReceptionServices grapeReceptionServices;
  final VarietalServices varietalServices;
  final List<String> nameVarietals;
  const FormAddGrapeReception({
    Key? key,
    required this.id,
    required this.date,
    required this.grapeReceptionServices,
    required this.varietalServices,
    required this.nameVarietals,
  }) : super(key: key);

  @override
  State<FormAddGrapeReception> createState() => _FormAddGrapeReceptionState();
}

class _FormAddGrapeReceptionState extends State<FormAddGrapeReception> {
  final ranchController = TextEditingController();
  final brixController = TextEditingController();
  final phController = TextEditingController();
  final kilosController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? varietalValue;

  onSave() async {
    if (_formKey.currentState!.validate()) {
      try {
        final varietal = varietalValue!;
        final rancho = ranchController.value.text.trim().toCapitalizedEachOne();
        final brix = double.parse(brixController.value.text.trim());
        final ph = double.parse(phController.value.text.trim());
        final kilos = double.parse(kilosController.value.text.trim());
        final responseGrape = await widget.grapeReceptionServices.add(
            GrapeReception(
                id: widget.id,
                date: widget.date,
                varietal: varietal,
                ranch: rancho,
                brix: brix,
                ph: ph,
                kilos: kilos,
                responsible: Globals.getCompleteName()));

        Varietal getVarietal = await widget.varietalServices.get(varietal);
        double newKilosReceived = getVarietal.kilosReceived + kilos;
        double newKilosUsed = getVarietal.kilosUsed + 0;
        final responseVarietal = await widget.varietalServices.update(Varietal(
            varietalId: varietal,
            kilosReceived: newKilosReceived,
            kilosUsed: newKilosUsed));
        if (responseGrape && responseVarietal) {
          Navigator.pop(context, true);
        } else {
          Navigator.pop(context, false);
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 370,
        width: 250,
        child: Column(
          children: [
            Text(
              'ID: ${widget.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonForm(
                validator: ((value) {
                  if (varietalValue == null) {
                    return 'Selecciona un varietal';
                  }
                  return null;
                }),
                onChanged: (String? value) =>
                    setState(() => varietalValue = value),
                hintText: 'Varietal',
                value: varietalValue,
                items: widget.nameVarietals),
            DataInput(
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
            Row(
              children: [
                Expanded(
                  child: DataInput(
                    labelText: 'Brix',
                    controller: brixController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa el brix';
                      } else if (!value.isANumber) {
                        return 'Enteros o decimales';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: DataInput(
                    labelText: 'PH',
                    controller: phController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa el brix';
                      } else if (!value.isANumber) {
                        return 'Enteros o decimales';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            DataInput(
              labelText: 'Kilos',
              controller: kilosController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresa los kilos';
                } else if (!value.isANumber) {
                  return 'Enteros o decimales';
                }
                return null;
              },
              onEditingComplete: onSave,
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
    );
  }
}

class FormEditGrapeReception extends StatefulWidget {
  final GrapeReception grapeReception;
  final GrapeReceptionServices grapeReceptionServices;
  final VarietalServices varietalServices;
  final List<String> varietalsName;
  const FormEditGrapeReception({
    Key? key,
    required this.grapeReception,
    required this.grapeReceptionServices,
    required this.varietalServices,
    required this.varietalsName,
  }) : super(key: key);

  @override
  State<FormEditGrapeReception> createState() => _FormEditGrapeReceptionState();
}

class _FormEditGrapeReceptionState extends State<FormEditGrapeReception> {
  final ranchController = TextEditingController();
  final brixController = TextEditingController();
  final phController = TextEditingController();
  final kilosController = TextEditingController();
  double? lastKilos;
  String? lastVarietal;
  String? varietalValue;

  @override
  void initState() {
    varietalValue = lastVarietal = widget.grapeReception.varietal;
    ranchController.text = widget.grapeReception.ranch;
    brixController.text = widget.grapeReception.brix.toString();
    phController.text = widget.grapeReception.ph.toString();
    kilosController.text = widget.grapeReception.kilos.toString();
    lastKilos = widget.grapeReception.kilos;

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  onEdit() async {
    if (_formKey.currentState!.validate()) {
      final currentVarietal = varietalValue;
      final rancho = ranchController.value.text.trim();
      final brix = double.parse(brixController.value.text.trim());
      final ph = double.parse(phController.value.text.trim());
      final kilos = double.parse(kilosController.value.text.trim());
      final responseGrape = await widget.grapeReceptionServices.update(
          GrapeReception(
              id: widget.grapeReception.id,
              date: widget.grapeReception.date,
              varietal: currentVarietal!,
              ranch: rancho,
              brix: brix,
              ph: ph,
              kilos: kilos,
              responsible: Globals.getCompleteName()));

      if (lastVarietal == currentVarietal) {
        Varietal getVarietal =
            await widget.varietalServices.get(currentVarietal);
        final newKilosReceived = getVarietal.kilosReceived - lastKilos! + kilos;
        final responseVarietal = await widget.varietalServices.update(Varietal(
            varietalId: getVarietal.varietalId,
            kilosReceived: newKilosReceived,
            kilosUsed: getVarietal.kilosUsed));
        if (responseGrape && responseVarietal) {
          Navigator.pop(context, true);
        } else {
          Navigator.pop(context, false);
        }
      } else {
        Varietal getBadVarietal =
            await widget.varietalServices.get(lastVarietal!);
        final badKilosReceived = getBadVarietal.kilosReceived - lastKilos!;
        final responseLastVarietal = await widget.varietalServices.update(
            Varietal(
                varietalId: getBadVarietal.varietalId,
                kilosReceived: badKilosReceived,
                kilosUsed: getBadVarietal.kilosUsed));
        Varietal getVarietal =
            await widget.varietalServices.get(currentVarietal);
        final newKilosReceived = getVarietal.kilosReceived + kilos;
        final responseVarietal = await widget.varietalServices.update(Varietal(
            varietalId: getVarietal.varietalId,
            kilosReceived: newKilosReceived,
            kilosUsed: getVarietal.kilosUsed));
        if (responseGrape && responseVarietal && responseLastVarietal) {
          Navigator.pop(context, true);
        } else {
          Navigator.pop(context, false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 370,
        width: 250,
        child: Column(
          children: [
            Text(
              'ID: ${widget.grapeReception.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonForm(
                validator: ((value) {
                  if (varietalValue == null) {
                    return 'Selecciona un varietal';
                  }
                  return null;
                }),
                onChanged: (String? value) =>
                    setState(() => varietalValue = value),
                hintText: 'Varietal',
                value: varietalValue,
                items: widget.varietalsName),
            DataInput(
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
            Row(
              children: [
                Expanded(
                  child: DataInput(
                    labelText: 'Brix',
                    controller: brixController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa el brix';
                      } else if (!value.isANumber) {
                        return 'Enteros o decimales';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: DataInput(
                    labelText: 'PH',
                    controller: phController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa el brix';
                      } else if (!value.isANumber) {
                        return 'Enteros o decimales';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            DataInput(
              labelText: 'Kilos',
              controller: kilosController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresa los kilos';
                } else if (!value.isANumber) {
                  return 'Enteros o decimales';
                }
                return null;
              },
              onEditingComplete: onEdit,
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
                  onPressed: onEdit,
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FormDeleteGrapeReception extends StatelessWidget {
  final GrapeReception grapeReception;
  final GrapeReceptionServices grapeReceptionServices;
  final VarietalServices varietalServices;
  FormDeleteGrapeReception(
      {Key? key,
      required this.grapeReception,
      required this.grapeReceptionServices,
      required this.varietalServices})
      : super(key: key);

  final grapeReceptionConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: mediaWidth > 820 ? 400 : 400,
      width: 400,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              color: Colors.red.shade200,
              child: Text.rich(TextSpan(children: [
                const TextSpan(
                  text:
                      'Esta acción elimina permanentemente el registro. Escribe ',
                ),
                TextSpan(
                  text: grapeReception.id,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  children: [
                    const TextSpan(text: ' y selecciona '),
                    const TextSpan(
                      text: 'ELIMINAR TODO ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                        text: 'si deseas eliminar el registro y los'),
                    TextSpan(
                      text:
                          ' Kilos recibidos de ${grapeReception.varietal} \n\n',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const TextSpan(
                  children: [
                    TextSpan(text: 'Selecciona '),
                    TextSpan(
                      text: 'Solo registro ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: 'para eliminar unicamente el registro de '),
                    TextSpan(
                      text: 'Recepción de Uva',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ]))),
          LabelInfo(label: 'Varietal', value: grapeReception.varietal),
          LabelInfo(label: 'Brix', value: grapeReception.brix.toString()),
          LabelInfo(label: 'PH', value: grapeReception.ph.toString()),
          LabelInfo(label: 'Kilos', value: grapeReception.kilos.toString()),
          DataInput(
            labelText: grapeReception.id!,
            controller: grapeReceptionConfirmController,
          ),
          Divider(
            height: 0.5,
            color: Colors.grey.shade200,
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DeleteButton(
                    label: 'ELIMINAR TODO',
                    onPressed: () async {
                      if (grapeReception.id ==
                          grapeReceptionConfirmController.value.text.trim()) {
                        final response = await grapeReceptionServices
                            .delete(grapeReception.id!);
                        Varietal getBadVarietal =
                            await varietalServices.get(grapeReception.varietal);
                        final badKilosReceived =
                            getBadVarietal.kilosReceived - grapeReception.kilos;
                        final badKilosUsed = getBadVarietal.kilosUsed + 0;
                        final responseLastVarietal =
                            await varietalServices.update(Varietal(
                                varietalId: grapeReception.varietal,
                                kilosReceived: badKilosReceived,
                                kilosUsed: badKilosUsed));
                        if (response && responseLastVarietal) {
                          Navigator.pop(context, true);
                        }
                      }
                    }),
                SecondaryDeleteButton(onPressed: () async {
                  if (grapeReception.id ==
                      grapeReceptionConfirmController.value.text.trim()) {
                    final response =
                        await grapeReceptionServices.delete(grapeReception.id!);
                    Navigator.pop(context, response);
                  }
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  getKilos(String varietal) async {
    final response = await varietalServices.get(varietal);
    return response.kilos;
  }
}
