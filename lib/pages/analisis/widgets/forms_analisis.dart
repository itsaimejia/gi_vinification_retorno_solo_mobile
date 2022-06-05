import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/analisis_model.dart';
import 'package:gi_vinification_retorno/services/analisis_services.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';
import 'package:gi_vinification_retorno/widgets/widgets_forms.dart';

class FormAddAnalisis extends StatefulWidget {
  final String id;
  final String date;
  final String responsible;
  final AnalisisServices analisisServices;
  final List<String> listReceptionIds;
  final List<String> listTankNames;
  const FormAddAnalisis(
      {Key? key,
      required this.id,
      required this.date,
      required this.analisisServices,
      required this.responsible,
      required this.listReceptionIds,
      required this.listTankNames})
      : super(key: key);

  @override
  State<FormAddAnalisis> createState() => _FormAddAnalisisState();
}

class _FormAddAnalisisState extends State<FormAddAnalisis> {
  final tipoController = TextEditingController();
  final brixController = TextEditingController();
  final phController = TextEditingController();
  final analisisRealizadoController = TextEditingController();
  final observacionesController = TextEditingController();
  List<String> listData = [];
  String? toAnalyze;
  String receptionOrTank = '';
  bool receptionChecked = false;
  bool tankChecked = false;

  final _formKey = GlobalKey<FormState>();

  onSave() {
    if (_formKey.currentState!.validate()) {
      final tipo = tipoController.value.text.trim().toCapitalizedEachOne();
      final brix = double.parse(brixController.value.text.trim());
      final ph = double.parse(phController.value.text.trim());
      final analisisRealizado =
          analisisRealizadoController.value.text.trim().toCapitalized();
      final observaciones = observacionesController.value.text;

      final response = widget.analisisServices.add(Analisis(
          itemAnalyzed: toAnalyze!,
          receptionOrTank: receptionOrTank,
          id: widget.id,
          date: widget.date,
          type: tipo,
          brix: brix,
          ph: ph,
          analysisPerformed: analisisRealizado,
          observations: observaciones,
          responsible: widget.responsible));
      Navigator.pop(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 490,
        width: 310,
        child: Column(
          children: [
            Text(
              'ID: ${widget.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                CheckBoxCustom(
                  enable: widget.listReceptionIds.isNotEmpty,
                  label: 'Recepciones uva',
                  value: receptionChecked,
                  onChanged: (value) {
                    setState(() {
                      toAnalyze = null;
                      receptionChecked = value!;
                      tankChecked = !value;
                      receptionOrTank = 'reception';
                      listData = widget.listReceptionIds;
                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                CheckBoxCustom(
                  enable: widget.listTankNames.isNotEmpty,
                  label: 'Tanques',
                  value: tankChecked,
                  onChanged: (value) {
                    setState(() {
                      toAnalyze = null;
                      tankChecked = value!;
                      receptionChecked = !value;
                      receptionOrTank = 'tank';
                      listData = widget.listTankNames;
                    });
                  },
                )
              ],
            ),
            DropdownButtonForm(
                validator: (value) {
                  if (toAnalyze == null) {
                    return 'Seleccionar item a analizar';
                  }
                  return null;
                },
                enabled: tankChecked || receptionChecked,
                value: toAnalyze,
                hintText: 'Selecciona que analizaras: ',
                items: listData,
                onChanged: (value) {
                  setState(() {
                    toAnalyze = value;
                  });
                }),
            DataInput(
              enabled: toAnalyze != null,
              labelText: 'Tipo',
              controller: tipoController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresa el tipo';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: DataInput(
                    enabled: toAnalyze != null,
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
                    enabled: toAnalyze != null,
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
              enabled: toAnalyze != null,
              labelText: 'Analisis realizado',
              controller: analisisRealizadoController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Llena este campo';
                }
                return null;
              },
            ),
            DataInput(
              enabled: toAnalyze != null,
              labelText: 'Observaciones',
              controller: observacionesController,
              maxLines: 4,
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
                  onPressed: toAnalyze != null ? onSave : () {},
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FormEditAnalisis extends StatefulWidget {
  final String responsible;
  final Analisis analisis;
  final AnalisisServices analisisServices;
  final List<String> listReceptionIds;
  final List<String> listTankNames;
  const FormEditAnalisis(
      {Key? key,
      required this.analisis,
      required this.analisisServices,
      required this.responsible,
      required this.listReceptionIds,
      required this.listTankNames})
      : super(key: key);

  @override
  State<FormEditAnalisis> createState() => _FormEditAnalisisState();
}

class _FormEditAnalisisState extends State<FormEditAnalisis> {
  final tipoController = TextEditingController();
  final brixController = TextEditingController();
  final phController = TextEditingController();
  final analisisRealizadoController = TextEditingController();
  final observacionesController = TextEditingController();
  List<String> listData = [];
  String? toAnalyze;
  String receptionOrTank = '';
  bool receptionChecked = false;
  bool tankChecked = false;

  @override
  void initState() {
    tipoController.text = widget.analisis.type;
    brixController.text = widget.analisis.brix.toString();
    phController.text = widget.analisis.ph.toString();
    analisisRealizadoController.text = widget.analisis.analysisPerformed;
    observacionesController.text = widget.analisis.observations;
    receptionChecked = widget.analisis.receptionOrTank == 'reception';
    tankChecked = widget.analisis.receptionOrTank == 'tank';
    listData = widget.analisis.receptionOrTank == 'reception'
        ? widget.listReceptionIds
        : widget.analisis.receptionOrTank == 'tank'
            ? widget.listTankNames
            : [];
    toAnalyze = widget.analisis.itemAnalyzed;
    receptionOrTank = widget.analisis.receptionOrTank;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  onEdit() {
    if (_formKey.currentState!.validate()) {
      final tipo = tipoController.value.text.trim().toCapitalizedEachOne();
      final brix = double.parse(brixController.value.text.trim());
      final ph = double.parse(phController.value.text.trim());
      final analisisRealizado =
          analisisRealizadoController.value.text.trim().toCapitalized();
      final observaciones = observacionesController.value.text.trim();
      final itemAnalyze = toAnalyze;
      final response = widget.analisisServices.update(Analisis(
          receptionOrTank: receptionOrTank,
          itemAnalyzed: itemAnalyze!,
          id: widget.analisis.id,
          date: widget.analisis.date,
          type: tipo,
          analysisPerformed: analisisRealizado,
          brix: brix,
          ph: ph,
          observations: observaciones,
          responsible: widget.responsible));
      Navigator.pop(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 490,
        width: 310,
        child: Column(
          children: [
            Text(
              'ID: ${widget.analisis.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                CheckBoxCustom(
                  enable: widget.listReceptionIds.isNotEmpty,
                  label: 'Recepciones uva',
                  value: receptionChecked,
                  onChanged: (value) {
                    setState(() {
                      toAnalyze = null;
                      receptionChecked = value!;
                      tankChecked = !value;
                      receptionOrTank = 'reception';
                      listData = widget.listReceptionIds;
                      toAnalyze = widget.analisis.itemAnalyzed;
                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                CheckBoxCustom(
                  enable: widget.listTankNames.isNotEmpty,
                  label: 'Tanques',
                  value: tankChecked,
                  onChanged: (value) {
                    setState(() {
                      toAnalyze = null;
                      tankChecked = value!;
                      receptionChecked = !value;
                      receptionOrTank = 'tank';
                      listData = widget.listTankNames;
                    });
                  },
                )
              ],
            ),
            DropdownButtonForm(
                validator: (value) {
                  if (toAnalyze == null) {
                    return 'Seleccionar item a analizar';
                  }
                  return null;
                },
                enabled: tankChecked || receptionChecked,
                value: toAnalyze,
                hintText: 'Selecciona que analizaras: ',
                items: listData,
                onChanged: (value) {
                  setState(() {
                    toAnalyze = value;
                  });
                }),
            DataInput(
              enabled: toAnalyze != null,
              labelText: 'Tipo',
              controller: tipoController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresa el tipo';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: DataInput(
                    enabled: toAnalyze != null,
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
                    enabled: toAnalyze != null,
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
              enabled: toAnalyze != null,
              labelText: 'Analisis realizado',
              controller: analisisRealizadoController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Llena este campo';
                }
                return null;
              },
            ),
            DataInput(
              enabled: toAnalyze != null,
              labelText: 'Observaciones',
              controller: observacionesController,
              maxLines: 4,
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
                  onPressed: toAnalyze != null ? onEdit : () {},
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FormDeleteAnalisis extends StatelessWidget {
  final Analisis analisis;
  final AnalisisServices analisisServices;
  const FormDeleteAnalisis(
      {Key? key, required this.analisis, required this.analisisServices})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: 200,
      child: Column(
        children: [
          LabelInfo(label: 'ID', value: analisis.id!),
          LabelInfo(label: 'Tipo', value: analisis.type),
          LabelInfo(label: 'Brix', value: '${analisis.brix}'),
          LabelInfo(label: 'PH', value: '${analisis.ph}'),
          LabelInfo(label: 'Análisis', value: analisis.analysisPerformed),
          Divider(
            height: 0.5,
            color: Colors.grey.shade200,
          ),
          const SizedBox(
            height: 15,
          ),
          DeleteButton(
              label: 'Eliminar',
              onPressed: () async {
                final response = await analisisServices.delete(analisis.id!);
                Navigator.pop(context, response);
              })
        ],
      ),
    );
  }
}
