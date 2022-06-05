// ignore_for_file: must_be_immutable, empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/tank_model.dart';
import 'package:gi_vinification_retorno/models/varietal_model.dart';
import 'package:gi_vinification_retorno/services/tank_services.dart';
import 'package:gi_vinification_retorno/services/varietal_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/widgets/widgets_pages.dart';
import 'package:provider/provider.dart';

class PrincipalPage extends StatelessWidget {
  PrincipalPage({Key? key}) : super(key: key);

  late double mediaHeight;
  late double mediaWidth;
  late VarietalServices varietalServices;
  late TankServices tankServices;

  @override
  Widget build(BuildContext context) {
    mediaHeight = MediaQuery.of(context).size.height;
    mediaWidth = MediaQuery.of(context).size.width;
    varietalServices = Provider.of<VarietalServices>(context);
    tankServices = Provider.of<TankServices>(context);
    varietalServices.getList();
    tankServices.getList();
    if (mediaWidth > 820) {
      return Table(
        children: [
          const TableRow(children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: Text(
                  'Inventario varietales',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: Text(
                  'Inventario tanques',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]),
          TableRow(children: [
            TableCell(
                child: Container(
              padding: const EdgeInsets.all(10),
              height: mediaHeight - 80,
              child: buildTableVarietal(),
            )),
            TableCell(
                child: Container(
              padding: const EdgeInsets.all(10),
              height: mediaHeight - 80,
              child: buildTableTanks(),
            ))
          ])
        ],
      );
    } else {
      return Table(
        children: [
          TableRow(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Text(
                    'Inventario varietales',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  width: double.infinity,
                  height: (mediaHeight / 2) - 70,
                  child: buildTableVarietal(),
                ),
              ],
            ),
          ]),
          TableRow(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                  child: Text(
                    'Inventario tanques',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 5, left: 10, right: 10, bottom: 5),
                  width: double.infinity,
                  height: (mediaHeight / 2) - 70,
                  child: buildTableTanks(),
                ),
              ],
            )
          ])
        ],
      );
    }
  }

  buildTableVarietal() {
    try {
      List<DataCell> getCells(List<dynamic> cells) => cells
          .map((data) => DataCell(
                Material(
                    type: MaterialType.transparency,
                    child: Text('$data',
                        style:
                            TextStyle(fontSize: mediaWidth > 820 ? 16 : 11))),
              ))
          .toList();

      List<DataRow> getRows(List<Varietal> dataList) =>
          dataList.map((Varietal data) {
            final cells = [data.varietalId, data.kilosReceived, data.kilosUsed];

            return DataRow(
                color: MaterialStateColor.resolveWith((states) {
                  return const Color(0xfffff0ff);
                }),
                cells: getCells(cells));
          }).toList();

      return varietalServices.loadData
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF762677),
              ),
            )
          : SingleChildScrollView(
              primary: false,
              child: DataTable(
                  horizontalMargin: 10,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xFF762677)),
                  columnSpacing: mediaWidth > 820 ? 10 : 4,
                  headingRowHeight: mediaWidth > 820 ? 45 : 25,
                  showCheckboxColumn: false,
                  columns: List<DataColumn>.generate(
                      Varietal.titles.length,
                      (index) => DataColumn(
                          label: Material(
                              type: MaterialType.transparency,
                              child: Text(Varietal.titles[index],
                                  style: TextStyle(
                                    color: backgroundColor,
                                    fontSize: mediaWidth > 820 ? 20 : 11,
                                    fontWeight: FontWeight.bold,
                                  ))))),
                  rows: getRows(varietalServices.listData)),
            );
    } catch (e) {}
  }

  buildTableTanks() {
    try {
      List<DataCell> getCells(List<dynamic> cells) => cells
          .map((data) => DataCell(
                Material(
                    type: MaterialType.transparency,
                    child: Text('$data',
                        style:
                            TextStyle(fontSize: mediaWidth > 820 ? 16 : 11))),
              ))
          .toList();

      List<DataRow> getRows(List<Tank> dataList) => dataList.map((Tank data) {
            final cells = [
              data.tankId,
              data.wineType,
              data.blem
                  .split(',')
                  .map((e) => '$e%'.trim().split('-'))
                  .map((e) => e.join(' '))
                  .join('\n'),
              data.liters
            ];

            return DataRow(
                color: MaterialStateColor.resolveWith((states) {
                  return const Color(0xfff0ecec);
                }),
                cells: getCells(cells));
          }).toList();

      return varietalServices.loadData
          ? const Center(
              child: CircularProgressIndicator(
                color: tankColor,
              ),
            )
          : SingleChildScrollView(
              primary: false,
              child: DataTable(
                  horizontalMargin: 10,
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => tankColor),
                  columnSpacing: mediaWidth > 820 ? 10 : 4,
                  headingRowHeight: mediaWidth > 820 ? 45 : 25,
                  showCheckboxColumn: false,
                  columns: List<DataColumn>.generate(
                      Tank.titles.length,
                      (index) => DataColumn(
                          label: Material(
                              type: MaterialType.transparency,
                              child: Text(Tank.titles[index],
                                  style: TextStyle(
                                    color: backgroundColor,
                                    fontSize: mediaWidth > 820 ? 20 : 11,
                                    fontWeight: FontWeight.bold,
                                  ))))),
                  rows: getRows(tankServices.listData)),
            );
    } catch (e) {}
  }
}
