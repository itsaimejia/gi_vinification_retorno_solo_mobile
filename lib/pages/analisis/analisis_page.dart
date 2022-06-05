// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/analisis_model.dart';
import 'package:gi_vinification_retorno/models/globals.dart';

import 'package:gi_vinification_retorno/pages/analisis/widgets/forms_analisis.dart';
import 'package:gi_vinification_retorno/services/analisis_services.dart';
import 'package:gi_vinification_retorno/services/grape_reception_services.dart';
import 'package:gi_vinification_retorno/services/tank_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/widgets/show_forms.dart';
import 'package:gi_vinification_retorno/widgets/widgets_pages.dart';
import 'package:gi_vinification_retorno/widgets/widgets_tables.dart';
import 'package:provider/provider.dart';

class AnalisisPage extends StatefulWidget {
  const AnalisisPage({Key? key}) : super(key: key);

  @override
  State<AnalisisPage> createState() => _AnalisisPageState();
}

class _AnalisisPageState extends State<AnalisisPage> {
  var dateController = TextEditingController();
  var inputController = TextEditingController();
  List<Analisis> listAnalisis = [];
  List<String> listTankNames = [];
  List<String> listReceptionIds = [];
  late AnalisisServices analisisServices;
  late GrapeReceptionServices grapeReceptionServices;
  late TankServices tankServices;
  bool isMouseEnterButtonAdd = false;
  bool sizableStateInputID = false;
  bool sizableStateDatePicker = false;
  late double mediaWidth;
  late double mediaHeight;

  @override
  Widget build(BuildContext context) {
    mediaWidth = MediaQuery.of(context).size.width;
    mediaHeight = MediaQuery.of(context).size.height;
    analisisServices = Provider.of<AnalisisServices>(context);
    tankServices = Provider.of<TankServices>(context);
    grapeReceptionServices = Provider.of<GrapeReceptionServices>(context);

    if (listAnalisis.isEmpty) {
      try {
        setState(() {
          analisisServices.getList();
          listAnalisis = analisisServices.listData;
        });
      } catch (e) {}
    }
    if (listReceptionIds.isEmpty) {
      setState(() {
        for (var e in grapeReceptionServices.listData) {
          listReceptionIds.add(e.id!);
        }
      });
    }
    if (listTankNames.isEmpty) {
      setState(() {
        for (var e in tankServices.listData) {
          listTankNames.add(e.tankId!);
        }
      });
    }

    void onAdd() async {
      final currentDate = DateTime.now();
      String date =
          '${currentDate.day}/${currentDate.month}/${currentDate.year}';
      await reloadData();

      String id = 'A0000';
      try {
        if (listAnalisis.last.id != null) {
          final codeId = int.parse(listAnalisis.last.id!.substring(1)) + 1;

          final formatCode = codeId < 10
              ? '000$codeId'
              : codeId < 100
                  ? '00$codeId'
                  : codeId < 1000
                      ? '0$codeId'
                      : '$codeId';

          id = 'A$formatCode';
        }
      } catch (e) {}

      try {
        final response = await showAddForm(
            context: context,
            date: date,
            content: FormAddAnalisis(
              listReceptionIds: listReceptionIds,
              listTankNames: listTankNames,
              id: id,
              date: date,
              analisisServices: analisisServices,
              responsible: Globals.getCompleteName(),
            ));
        if (response) {
          reloadData();
        }
      } catch (e) {}
    }

    if (analisisServices.loadData) {
      return Container(
        alignment: Alignment.center,
        color: backgroundColor,
        child: const CircularProgressIndicator(),
      );
    } else {
      return GestureDetector(
        onTap: setStatesInputs,
        child: Scaffold(
          backgroundColor: backgroundColor,
          floatingActionButton: mediaWidth < 820
              ? FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: onAdd,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                )
              : null,
          body: Container(
              padding: EdgeInsets.only(
                  left: mediaWidth > 820 ? 10 : 0,
                  right: mediaWidth > 820 ? 10 : 0),
              height: double.infinity,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Container(
                        height: mediaWidth > 820 ? 99 : 60,
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Row(
                          children: [
                            if (mediaWidth > 820)
                              Row(
                                children: [
                                  AddButton(
                                    onTap: onAdd,
                                    onEnter: (event) => setState(
                                        () => isMouseEnterButtonAdd = true),
                                    onExit: (event) => setState(
                                        () => isMouseEnterButtonAdd = false),
                                    isMouseEnter: isMouseEnterButtonAdd,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                            InputSearch(
                              onTap: stateInputID,
                              fontSize: mediaWidth > 820 ? 15 : 12,
                              iconSize: mediaWidth > 820 ? 23 : 18,
                              sizableState: sizableStateInputID,
                              maxWidth: 100,
                              tooltipMessage: 'Buscar por ID',
                              labelText: "ID",
                              controller: inputController,
                              onSubmitted: filterByID,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            InputDate(
                                iconSize: mediaWidth > 820 ? 23 : 18,
                                fontSize: mediaWidth > 820 ? 15 : 12,
                                sizableState: sizableStateDatePicker,
                                labelText: dateController.text,
                                onTap: filterByDate),
                            if (mediaWidth < 820) const Spacer(),
                            ClearFiltersButton(
                                size: mediaWidth > 820 ? 20 : 15,
                                onPressed: clearFilters),
                            if (mediaWidth > 820) const Spacer(),
                            if (mediaWidth > 820)
                              const SizedBox(
                                width: 15,
                              ),
                          ],
                        )),
                  ]),
                  const TableRow(children: [
                    Divider(
                      color: secundaryColor,
                    )
                  ]),
                  TableRow(children: [
                    SizedBox(
                      height: mediaHeight - 170,
                      child: SingleChildScrollView(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          child: buildTable()),
                    )
                  ])
                ],
              )),
        ),
      );
    }
  }

  void filterByID(String value) async {
    if (value.isNotEmpty) {
      try {
        Analisis response = analisisServices.listData
            .firstWhere((element) => element.id == value.toUpperCase());
        if (response.toJson().isNotEmpty) {
          setState(() {
            listAnalisis.clear();
            listAnalisis.add(response);
          });
        } else {
          filterNoData(value);
        }
      } catch (e) {
        filterNoData(value);
      }
    }
  }

  void filterByDate() async {
    stateInputDate();
    try {
      dateController.text = await getDate(context);
      if (dateController.text.isNotEmpty) {
        List<Analisis> response = analisisServices.listData
            .where((element) => element.date == dateController.value.text)
            .toList();
        if (response.isNotEmpty) {
          stateInputDate();
          setState(() {
            inputController.clear();
            listAnalisis.clear();
            for (var element in response) {
              listAnalisis.add(element);
            }
          });
        } else {
          filterNoData('0/0/0');
          dateController.clear();
          setStatesInputs();
        }
      }
    } catch (e) {
      dateController.clear();
      setStatesInputs();
    }
  }

  filterNoData(value) {
    if (listAnalisis.isNotEmpty) {
      if (value.isNotEmpty) {
        final noDataResponse = Analisis(
            id: 'no data',
            date: 'no data',
            type: 'no data',
            observations: 'no data',
            ph: -1,
            analysisPerformed: 'no data',
            responsible: '',
            itemAnalyzed: 'no data',
            receptionOrTank: '',
            brix: -1);
        setState(() {
          listAnalisis.clear();
          listAnalisis.add(noDataResponse);
        });
      }
    }
  }

  Future<void> reloadData() async {
    listAnalisis.clear();
    await analisisServices.getList();
    listAnalisis = analisisServices.listData;
  }

  void setStatesInputs() => setState(() {
        sizableStateInputID = false;
        sizableStateDatePicker = false;
      });
  void clearFilters() {
    setState(() {
      dateController.clear();
      inputController.clear();
      setStatesInputs();
      reloadData();
    });
  }

  void stateInputID() => setState(() {
        sizableStateDatePicker = false;
        sizableStateInputID = true;
      });
  void stateInputDate() => setState(() {
        sizableStateDatePicker = true;
        sizableStateInputID = false;
      });

  buildTable() {
    List<DataCell> getCells(List<dynamic> cells) => cells
        .map((data) => DataCell(
              Material(
                  type: MaterialType.transparency,
                  child: Text('$data',
                      style: TextStyle(fontSize: mediaWidth > 820 ? 16 : 11))),
            ))
        .toList();

    List<DataRow> getRows(List<Analisis> dataList) =>
        dataList.map((Analisis data) {
          final cells = [
            data.date,
            data.id,
            data.type,
            data.brix,
            data.ph,
            data.analysisPerformed,
            data.itemAnalyzed
          ];

          return DataRow(
              color: MaterialStateColor.resolveWith((states) {
                return contentTableColor;
              }),
              cells: getCells(cells) +
                  [
                    DataCell(ButtonShowObservation(
                      observations: data.observations,
                    )),
                    DataCell(
                      ActionsIndexTable(
                        enabled: !(data.id == 'no data'),
                        userType: Globals.getUserRole(),
                        iconSize: mediaWidth < 820 ? 16 : 25,
                        onEdited: () async {
                          try {
                            final response = await showEditForm(
                                context: context,
                                content: FormEditAnalisis(
                                    listReceptionIds: listReceptionIds,
                                    listTankNames: listTankNames,
                                    responsible: Globals.getCompleteName(),
                                    analisis: data,
                                    analisisServices: analisisServices));
                            if (response) {
                              await reloadData();
                            }
                          } catch (e) {}
                        },
                        onDeleted: () async {
                          try {
                            final response = await showDeleteForm(
                                context: context,
                                content: FormDeleteAnalisis(
                                    analisis: data,
                                    analisisServices: analisisServices));
                            if (response) {
                              await reloadData();
                            }
                          } catch (e) {}
                          await reloadData();
                        },
                        onViewResponsible: () {
                          showDialog(
                              context: context,
                              builder: (__) => AlertDialog(
                                    title: const Text('Responsable:'),
                                    content: Text(data.responsible),
                                  ));
                        },
                      ),
                    )
                  ]);
        }).toList();

    return DataTable(
        horizontalMargin: 10,
        headingRowColor:
            MaterialStateColor.resolveWith((states) => headerTableColor),
        columnSpacing: mediaWidth > 820 ? 10 : 4,
        headingRowHeight: mediaWidth > 820 ? 45 : 25,
        showCheckboxColumn: false,
        columns: List<DataColumn>.generate(
            Analisis.titles.length,
            (index) => DataColumn(
                label: Material(
                    type: MaterialType.transparency,
                    child: Text(Analisis.titles[index],
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: mediaWidth > 820 ? 20 : 11,
                          fontWeight: FontWeight.bold,
                        ))))),
        rows: getRows(listAnalisis));
  }
}
