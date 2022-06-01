// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/fermentation_model.dart';
import 'package:gi_vinification_retorno/models/globals.dart';
import 'package:gi_vinification_retorno/pages/fermentations/widgets/excel_fermentations.dart';
import 'package:gi_vinification_retorno/pages/fermentations/widgets/forms_fermentations.dart';
import 'package:gi_vinification_retorno/services/fermentations_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/widgets/show_forms.dart';
import 'package:gi_vinification_retorno/widgets/widgets_pages.dart';
import 'package:gi_vinification_retorno/widgets/widgets_tables.dart';
import 'package:provider/provider.dart';

class FermentationsPage extends StatefulWidget {
  const FermentationsPage({Key? key}) : super(key: key);

  @override
  State<FermentationsPage> createState() => _FermentationsPageState();
}

class _FermentationsPageState extends State<FermentationsPage> {
  var dateController = TextEditingController();
  var inputController = TextEditingController();
  List<Fermentation> listFermentations = [];
  late FermentationsServices fermentationsServices;
  bool isMouseEnterButtonAdd = false;
  bool sizableStateInputID = false;
  bool sizableStateDatePicker = false;
  String? whoName;
  late double mediaWidth;
  late double mediaHeight;
  @override
  Widget build(BuildContext context) {
    mediaWidth = MediaQuery.of(context).size.width;
    mediaHeight = MediaQuery.of(context).size.height;
    fermentationsServices = Provider.of<FermentationsServices>(context);

    if (listFermentations.isEmpty) {
      try {
        setState(() {
          fermentationsServices.getList();
          listFermentations = fermentationsServices.listData;
        });
      } catch (e) {}
    }
    void getNames() async {
      setState(() {
        final names = Globals.getUserName().split(' ');
        final name = names.length > 1
            ? '${names[0]} ${names[1].substring(0, 1)}.'
            : names[0];
        final surnames = Globals.getUserSurnames().split(' ');
        final surname = '${surnames[0].substring(0, 3)}.';
        whoName = '$name $surname';
      });
    }

    void onAdd() async {
      getNames();
      final currentDate = DateTime.now();
      String date =
          '${currentDate.day}/${currentDate.month}/${currentDate.year}';
      await reloadData();

      String id = 'F0000';
      try {
        if (listFermentations.last.id != null) {
          final codeId = int.parse(listFermentations.last.id!.substring(1)) + 1;

          final formatCode = codeId < 10
              ? '000$codeId'
              : codeId < 100
                  ? '00$codeId'
                  : codeId < 1000
                      ? '0$codeId'
                      : '$codeId';

          id = 'F$formatCode';
        }
      } catch (e) {}

      try {
        final response = await showAddForm(
            context: context,
            date: date,
            content: FormAddFermentation(
                id: id,
                date: date,
                whoMade: whoName!,
                fermentationsServices: fermentationsServices));
        if (response) {
          reloadData();
        }
      } catch (e) {}
    }

    if (fermentationsServices.loadData) {
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
                    color: Colors.black,
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
                            if (mediaWidth > 820)
                              ExcelButton(onPressed: () async {
                                await reloadData();
                                if (listFermentations.isNotEmpty) {
                                  createExcelFermentations(
                                      listFermentations: listFermentations);
                                }
                              })
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
        Fermentation response = fermentationsServices.listData
            .firstWhere((element) => element.id == value.toUpperCase());
        if (response.toJson().isNotEmpty) {
          setState(() {
            listFermentations.clear();
            listFermentations.add(response);
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
        List<Fermentation> response = fermentationsServices.listData
            .where((element) => element.date == dateController.value.text)
            .toList();
        if (response.isNotEmpty) {
          stateInputDate();
          setState(() {
            inputController.clear();
            listFermentations.clear();
            for (var element in response) {
              listFermentations.add(element);
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
    if (listFermentations.isNotEmpty) {
      if (value.isNotEmpty) {
        final noDataResponse = Fermentation(
            whoMade: 'no data',
            id: 'no data',
            date: 'no data',
            activity: 'no data',
            observations: 'no data',
            time: -1,
            responsible: 'no data');
        setState(() {
          listFermentations.clear();
          listFermentations.add(noDataResponse);
        });
      }
    }
  }

  Future<void> reloadData() async {
    listFermentations.clear();
    await fermentationsServices.getList();
    listFermentations = fermentationsServices.listData;
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

    List<DataRow> getRows(List<Fermentation> dataList) =>
        dataList.map((Fermentation data) {
          final cells = [
            data.date,
            data.id,
            data.activity,
            data.time,
            data.whoMade,
          ];

          return DataRow(
              color: MaterialStateColor.resolveWith((states) {
                return contentTableColor;
              }),
              cells: getCells(cells) +
                  [
                    DataCell(
                        ButtonShowObservation(observations: data.observations)),
                    DataCell(
                      ActionsIndexTable(
                        userType: Globals.getUserRole(),
                        enabled: !(data.id == 'no data'),
                        iconSize: mediaWidth < 820 ? 16 : 25,
                        onEdited: () async {
                          try {
                            final response = await showEditForm(
                                context: context,
                                content: FormEditFermentation(
                                    fermentation: data,
                                    fermentationsServices:
                                        fermentationsServices));
                            if (response) {
                              await reloadData();
                            }
                          } catch (e) {}
                        },
                        onDeleted: () async {
                          try {
                            final response = await showDeleteForm(
                                context: context,
                                content: FormDeleteFermentation(
                                    fermentation: data,
                                    fermentationsServices:
                                        fermentationsServices));
                            if (response) {
                              await reloadData();
                            }
                            await reloadData();
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
            Fermentation.titles.length,
            (index) => DataColumn(
                label: Material(
                    type: MaterialType.transparency,
                    child: Text(Fermentation.titles[index],
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: mediaWidth > 820 ? 20 : 11,
                          fontWeight: FontWeight.bold,
                        ))))),
        rows: getRows(listFermentations));
  }
}
