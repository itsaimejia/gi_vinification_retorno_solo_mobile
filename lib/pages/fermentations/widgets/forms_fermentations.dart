import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/fermentation_model.dart';
import 'package:gi_vinification_retorno/models/globals.dart';
import 'package:gi_vinification_retorno/services/fermentations_services.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';
import 'package:gi_vinification_retorno/widgets/widgets_forms.dart';

class FormAddFermentation extends StatefulWidget {
  final String id;
  final String date;
  final String whoMade;
  final FermentationsServices fermentationsServices;
  const FormAddFermentation(
      {Key? key,
      required this.id,
      required this.date,
      required this.fermentationsServices,
      required this.whoMade})
      : super(key: key);

  @override
  State<FormAddFermentation> createState() => _FormAddFermentationState();
}

class _FormAddFermentationState extends State<FormAddFermentation> {
  final activityController = TextEditingController();
  final timeController = TextEditingController();
  final observationsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  onSave() {
    if (_formKey.currentState!.validate()) {
      final activity = activityController.value.text.trim().toCapitalized();
      final time = timeController.value.text.trim();
      final observations = observationsController.value.text.trim();

      final response = widget.fermentationsServices.add(Fermentation(
          id: widget.id,
          date: widget.date,
          whoMade: widget.whoMade,
          responsible: Globals.getCompleteName(),
          activity: activity,
          time: int.parse(time),
          observations: observations));

      Navigator.pop(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 260,
        width: 350,
        child: Column(
          children: [
            Text(
              'ID: ${widget.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Responsable: ${widget.whoMade}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DataInput(
                    width: double.infinity,
                    labelText: 'Actividad',
                    controller: activityController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa la actividad';
                      } else if (!value.isAName) {
                        return 'No se aceptan números';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: DataInput(
                    width: double.infinity,
                    labelText: 'Tiempo en mins.',
                    controller: timeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa el tiempo';
                      } else if (value.isAWord) {
                        return 'Solo números';
                      } else if (!value.isAIntNumber) {
                        return 'Tiempo en minutos';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            DataInput(
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

class FormEditFermentation extends StatefulWidget {
  final Fermentation fermentation;
  final FermentationsServices fermentationsServices;
  const FormEditFermentation(
      {Key? key,
      required this.fermentation,
      required this.fermentationsServices})
      : super(key: key);

  @override
  State<FormEditFermentation> createState() => _FormEditFermentationState();
}

class _FormEditFermentationState extends State<FormEditFermentation> {
  final activityController = TextEditingController();
  final timeController = TextEditingController();
  final observationsController = TextEditingController();

  @override
  void initState() {
    activityController.text = widget.fermentation.activity;
    timeController.text = widget.fermentation.time.toString();
    observationsController.text = widget.fermentation.observations;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  onEdit() async {
    if (_formKey.currentState!.validate()) {
      final activity = activityController.value.text.trim();
      final time = timeController.value.text.trim();
      final observations = observationsController.value.text.trim();
      final response = widget.fermentationsServices.update(Fermentation(
          whoMade: widget.fermentation.whoMade,
          id: widget.fermentation.id,
          date: widget.fermentation.date,
          activity: activity,
          time: int.parse(time),
          responsible: Globals.getCompleteName(),
          observations: observations));
      Navigator.pop(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 260,
        width: 350,
        child: Column(
          children: [
            Text(
              'ID: ${widget.fermentation.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Responsable: ${widget.fermentation.responsible}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DataInput(
                    width: double.infinity,
                    labelText: 'Actividad',
                    controller: activityController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa la actividad';
                      } else if (!value.isAName) {
                        return 'No se aceptan números';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: DataInput(
                    width: double.infinity,
                    labelText: 'Tiempo en mins.',
                    controller: timeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa el tiempo';
                      } else if (value.isAWord) {
                        return 'Solo números';
                      } else if (!value.isAIntNumber) {
                        return 'Tiempo en minutos';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            DataInput(
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

class FormDeleteFermentation extends StatelessWidget {
  final Fermentation fermentation;
  final FermentationsServices fermentationsServices;
  const FormDeleteFermentation(
      {Key? key,
      required this.fermentation,
      required this.fermentationsServices})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        children: [
          LabelInfo(label: 'ID', value: fermentation.id!),
          LabelInfo(label: 'Actividad', value: fermentation.activity),
          LabelInfo(label: 'Tiempo', value: fermentation.time.toString()),
          LabelInfo(label: 'Responsable', value: fermentation.responsible),
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
                final response =
                    await fermentationsServices.delete(fermentation.id!);
                Navigator.pop(context, response);
              })
        ],
      ),
    );
  }
}
