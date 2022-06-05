// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/globals.dart';
import 'package:gi_vinification_retorno/models/wine_model.dart';
import 'package:gi_vinification_retorno/pages/fermentations/widgets/form_configure_tanks.dart';
import 'package:gi_vinification_retorno/pages/fermentations/widgets/forms_wine.dart';
import 'package:gi_vinification_retorno/services/tank_services.dart';
import 'package:gi_vinification_retorno/services/varietal_services.dart';
import 'package:gi_vinification_retorno/services/wine_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/widgets/show_forms.dart';
import 'package:gi_vinification_retorno/widgets/widgets_pages.dart';
import 'package:gi_vinification_retorno/widgets/widgets_tables.dart';
import 'package:provider/provider.dart';

class WinePage extends StatefulWidget {
  const WinePage({Key? key}) : super(key: key);

  @override
  State<WinePage> createState() => _WinePageState();
}

class _WinePageState extends State<WinePage> {
  var dateController = TextEditingController();
  var inputController = TextEditingController();
  List<Wine> listWines = [];
  List<String> listVarietalsName = [];
  late WineServices wineServices;
  late TankServices tankServices;
  late VarietalServices varietalServices;
  bool isMouseEnterButtonAdd = false;
  bool sizableStateInputID = false;
  bool sizableStateDatePicker = false;
  late double mediaWidth;
  late double mediaHeight;

  @override
  Widget build(BuildContext context) {
    mediaWidth = MediaQuery.of(context).size.width;
    mediaHeight = MediaQuery.of(context).size.height;
    wineServices = Provider.of<WineServices>(context);
    tankServices = Provider.of<TankServices>(context);
    varietalServices = Provider.of<VarietalServices>(context);

    if (listWines.isEmpty) {
      try {
        setState(() {
          wineServices.getList();
          listWines = wineServices.listData;
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

    void onConfigureTanks() async {
      try {
        await showDialog(
            context: context,
            builder: (__) => AlertDialog(
                title: const Text(
                  "Configurar blem de tanques",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                elevation: 5,
                backgroundColor: Colors.white,
                content: FormConfigureTank(
                  nameVarietals: listVarietalsName,
                  tankServices: tankServices,
                )));
      } catch (e) {}
    }

    void onAdd() async {
      tankServices.getList();
      List<String> listTanksWithBlem = [];
      for (var tank in tankServices.listData) {
        if (tank.blem.isNotEmpty) {
          listTanksWithBlem.add(tank.tankId!);
        }
      }
      final currentDate = DateTime.now();
      String date =
          '${currentDate.day}/${currentDate.month}/${currentDate.year}';

      String id = 'V0000';
      try {
        if (listWines.last.id != null) {
          final codeId = int.parse(listWines.last.id!.substring(1)) + 1;
          final formatCode = codeId < 10
              ? '000$codeId'
              : codeId < 100
                  ? '00$codeId'
                  : codeId < 1000
                      ? '0$codeId'
                      : '$codeId';

          id = 'V$formatCode';
        }
      } catch (e) {}

      try {
        final response = await showAddForm(
            context: context,
            date: date,
            content: FormAddWine(
              id: id,
              date: date,
              wineServices: wineServices,
              tankServices: tankServices,
              nameVarietals: listVarietalsName,
              varietalServices: varietalServices,
            ));
        if (response) {
          reloadData();
        }
      } catch (e) {}
    }

    if (wineServices.loadData) {
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: mediaWidth < 820
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      backgroundColor: tankColor,
                      onPressed: onConfigureTanks,
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: onAdd,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                  ],
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
                              ElevatedButton(
                                onPressed: onConfigureTanks,
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(10),
                                    primary: tankColor),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("Configurar tanque")
                                  ],
                                ),
                              ),
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
        Wine response = wineServices.listData
            .firstWhere((element) => element.id == value.toUpperCase());
        if (response.toJson().isNotEmpty) {
          setState(() {
            listWines.clear();
            listWines.add(response);
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
        List<Wine> response = wineServices.listData
            .where((element) => element.date == dateController.value.text)
            .toList();
        if (response.isNotEmpty) {
          stateInputDate();
          setState(() {
            inputController.clear();
            listWines.clear();
            for (var element in response) {
              listWines.add(element);
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
    if (listWines.isNotEmpty) {
      if (value.isNotEmpty) {
        final noDataResponse = Wine(
          responsible: '',
          blem: 'no-data%',
          id: 'no data',
          date: 'no data',
          type: 'no data',
          anada: 'no data',
          ranch: 'no data',
          tankName: 'no data',
          observations: 'no data',
          liters: -1,
        );
        setState(() {
          listWines.clear();
          listWines.add(noDataResponse);
        });
      }
    }
  }

  Future<void> reloadData() async {
    listWines.clear();
    await wineServices.getList();
    listWines = wineServices.listData;
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

    List<DataRow> getRows(List<Wine> dataList) => dataList.map((Wine data) {
          final cells = [
            data.date,
            data.id,
            data.type,
            data.ranch,
            data.anada,
            data.tankName,
            data.blem
                .split(',')
                .map((x) => x.trim().split('-'))
                .map((w) => '${w[0]} ${w[1]}%')
                .join('\n'),
            data.liters,
          ];

          return DataRow(
              color: MaterialStateColor.resolveWith((states) {
                return contentTableColor;
              }),
              cells: getCells(cells) +
                  [
                    DataCell(
                        ButtonShowObservation(observations: data.observations)),
                    DataCell(Row(
                      children: [
                        GestureDetector(
                          onTap: !(data.id == 'no data')
                              ? () async {
                                  try {
                                    await showDeleteForm(
                                        context: context,
                                        content: FormDeleteWine(
                                          wine: data,
                                          wineServices: wineServices,
                                          tankServices: tankServices,
                                          varietalServices: varietalServices,
                                        ));
                                    await reloadData();
                                  } catch (e) {}
                                }
                              : null,
                          child: Tooltip(
                            message: 'Eliminar',
                            child: Icon(
                              Icons.remove,
                              color: !(data.id == 'no data')
                                  ? Colors.red
                                  : Colors.grey.shade800,
                              size: mediaWidth < 820 ? 16 : 25,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (Globals.getUserRole() == 'Admin')
                          GestureDetector(
                            onTap: !(data.id == 'no data')
                                ? () {
                                    showDialog(
                                        context: context,
                                        builder: (__) => AlertDialog(
                                              title: const Text('Responsable:'),
                                              content: Text(data.responsible),
                                            ));
                                  }
                                : null,
                            child: Tooltip(
                              message: 'Responsable',
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                color: !(data.id == 'no data')
                                    ? Colors.black
                                    : Colors.grey.shade800,
                                size: mediaWidth < 820 ? 16 : 25,
                              ),
                            ),
                          ),
                      ],
                    ))
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
            Wine.titles.length,
            (index) => DataColumn(
                label: Material(
                    type: MaterialType.transparency,
                    child: Text(Wine.titles[index],
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: mediaWidth > 820 ? 20 : 11,
                          fontWeight: FontWeight.bold,
                        ))))),
        rows: getRows(listWines));
  }
}
