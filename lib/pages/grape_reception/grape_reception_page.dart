// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/globals.dart';
import 'package:gi_vinification_retorno/models/grape_reception_model.dart';
import 'package:gi_vinification_retorno/pages/grape_reception/widgets/forms_grape_reception.dart';
import 'package:gi_vinification_retorno/services/grape_reception_services.dart';
import 'package:gi_vinification_retorno/services/varietal_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';
import 'package:gi_vinification_retorno/widgets/show_forms.dart';
import 'package:gi_vinification_retorno/widgets/widgets_pages.dart';
import 'package:gi_vinification_retorno/widgets/widgets_tables.dart';
import 'package:provider/provider.dart';

class GrapeReceptionPage extends StatefulWidget {
  const GrapeReceptionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<GrapeReceptionPage> createState() => _GrapeReceptionPageState();
}

class _GrapeReceptionPageState extends State<GrapeReceptionPage> {
  var dateController = TextEditingController();
  var inputController = TextEditingController();
  List<GrapeReception> listGrapeReception = [];
  List<String> listVarietalsName = [];
  late GrapeReceptionServices grapeReceptionServices;
  late VarietalServices varietalServices;
  bool isMouseEnterButtonAdd = false;
  bool sizableStateInput = false;
  bool sizableStateDatePicker = false;
  late double mediaWidth;
  late double mediaHeight;

  @override
  Widget build(BuildContext context) {
    mediaWidth = MediaQuery.of(context).size.width;
    mediaHeight = MediaQuery.of(context).size.height;
    grapeReceptionServices = Provider.of<GrapeReceptionServices>(context);
    varietalServices = Provider.of<VarietalServices>(context);

    if (listGrapeReception.isEmpty) {
      try {
        setState(() {
          grapeReceptionServices.getList();
          listGrapeReception = grapeReceptionServices.listData;
        });
      } catch (e) {}
    }
    if (listVarietalsName.isEmpty) {
      try {
        setState(() {
          varietalServices.getList();
          for (var element in varietalServices.listData) {
            listVarietalsName.add(element.varietalId!);
          }
        });
      } catch (e) {}
    }
    onAdd() async {
      final currentDate = DateTime.now();
      String date =
          '${currentDate.day}/${currentDate.month}/${currentDate.year}';
      await reloadData();

      String id = 'R0000';
      try {
        if (listGrapeReception.last.id != null) {
          final codeId =
              int.parse(listGrapeReception.last.id!.substring(1)) + 1;

          final formatCode = codeId < 10
              ? '000$codeId'
              : codeId < 100
                  ? '00$codeId'
                  : codeId < 1000
                      ? '0$codeId'
                      : '$codeId';

          id = 'R$formatCode';
        }
      } catch (e) {}
      try {
        await showAddForm(
            context: context,
            date: date,
            content: FormAddGrapeReception(
              id: id,
              date: date,
              grapeReceptionServices: grapeReceptionServices,
              nameVarietals: listVarietalsName,
              varietalServices: varietalServices,
            )).then((value) {
          if (value) {
            reloadData();
          }
        });
      } catch (e) {}
    }

    if (grapeReceptionServices.loadData) {
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
                              onTap: stateInput,
                              fontSize: mediaWidth > 820 ? 15 : 12,
                              iconSize: mediaWidth > 820 ? 23 : 18,
                              sizableState: sizableStateInput,
                              maxWidth: 200,
                              tooltipMessage: 'Buscar por o varietal',
                              labelText: "ID/Varietal",
                              controller: inputController,
                              onSubmitted: (value) {
                                if (value.toUpperCase().isAnID) {
                                  filterByID(value);
                                } else if (value.isAName) {
                                  filterByVarietal(value);
                                } else {
                                  filterNoData(value);
                                }
                              },
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

  reloadData() async {
    listGrapeReception.clear();
    await grapeReceptionServices.getList();
    listGrapeReception = grapeReceptionServices.listData;
  }

  void filterByID(String value) async {
    if (value.isNotEmpty) {
      try {
        GrapeReception response = grapeReceptionServices.listData
            .firstWhere((element) => element.id == value.toUpperCase());
        if (response.toJson().isNotEmpty) {
          setState(() {
            listGrapeReception.clear();
            listGrapeReception.add(response);
          });
        } else {
          filterNoData(value);
        }
      } catch (e) {
        filterNoData(value);
      }
    }
  }

  void filterByVarietal(value) async {
    if (value.isNotEmpty) {
      try {
        List<GrapeReception> response = grapeReceptionServices.listData
            .where((element) =>
                element.varietal.toLowerCase() ==
                value.toString().toLowerCase())
            .toList();
        if (response.isNotEmpty) {
          setState(() {
            dateController.clear();
            listGrapeReception.clear();
            for (var element in response) {
              listGrapeReception.add(element);
            }
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
        List<GrapeReception> response = grapeReceptionServices.listData
            .where((element) => element.date == dateController.value.text)
            .toList();
        if (response.isNotEmpty) {
          stateInputDate();
          setState(() {
            inputController.clear();
            listGrapeReception.clear();
            for (var element in response) {
              listGrapeReception.add(element);
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
    if (value.isNotEmpty) {
      if (listGrapeReception.isNotEmpty) {
        final noDataResponse = GrapeReception(
            id: 'no data',
            date: 'no data',
            varietal: 'no data',
            ranch: 'no data',
            brix: -1,
            ph: -1,
            kilos: -1,
            responsible: '');
        setState(() {
          listGrapeReception.clear();
          listGrapeReception.add(noDataResponse);
        });
      }
    }
  }

  void setStatesInputs() => setState(() {
        sizableStateInput = false;
        sizableStateDatePicker = false;
      });

  void stateInput() => setState(() {
        sizableStateDatePicker = false;
        sizableStateInput = true;
      });
  void stateInputDate() => setState(() {
        sizableStateDatePicker = true;
        sizableStateInput = false;
      });

  void clearFilters() {
    setState(() {
      inputController.clear();
      dateController.clear();
      setStatesInputs();
      reloadData();
    });
  }

  buildTable() {
    List<DataCell> getCells(List<dynamic> cells) => cells
        .map((data) => DataCell(
              Material(
                  type: MaterialType.transparency,
                  child: Text('$data',
                      style: TextStyle(fontSize: mediaWidth > 820 ? 16 : 11))),
            ))
        .toList();

    List<DataRow> getRows(List<GrapeReception> dataList) =>
        dataList.map((GrapeReception data) {
          final cells = [
            data.date,
            data.id,
            data.varietal,
            data.ranch,
            data.brix,
            data.ph,
            data.kilos,
          ];

          return DataRow(
              color: MaterialStateColor.resolveWith((states) {
                return contentTableColor;
              }),
              cells: getCells(cells) +
                  [
                    DataCell(
                      ActionsIndexTable(
                        enabled: !(data.id == 'no data'),
                        iconSize: mediaWidth < 820 ? 16 : 25,
                        userType: Globals.getUserRole(),
                        onEdited: () async {
                          try {
                            final response = await showEditForm(
                                context: context,
                                content: FormEditGrapeReception(
                                  grapeReception: data,
                                  grapeReceptionServices:
                                      grapeReceptionServices,
                                  varietalServices: varietalServices,
                                  varietalsName: listVarietalsName,
                                ));
                            if (response) {
                              await reloadData();
                            }
                          } catch (e) {}
                        },
                        onDeleted: () async {
                          try {
                            final response = await showDeleteForm(
                                context: context,
                                content: FormDeleteGrapeReception(
                                  grapeReception: data,
                                  grapeReceptionServices:
                                      grapeReceptionServices,
                                  varietalServices: varietalServices,
                                ));
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
            GrapeReception.titles.length,
            (index) => DataColumn(
                label: Material(
                    type: MaterialType.transparency,
                    child: Text(GrapeReception.titles[index],
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: mediaWidth > 820 ? 20 : 11,
                          fontWeight: FontWeight.bold,
                        ))))),
        rows: getRows(listGrapeReception));
  }
}
