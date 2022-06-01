// ignore_for_file: empty_catches, avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';
import 'package:gi_vinification_retorno/models/grape_reception_model.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<void> createExcelGrapeReception(
    {required List<GrapeReception> listGrapeReception}) async {
  try {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    for (var i = 1; i < GrapeReception.titles.length; i++) {
      sheet.getRangeByIndex(1, i).setText(GrapeReception.titles[i - 1]);
    }

    for (var r = 2; r < listGrapeReception.length + 2; r++) {
      sheet.getRangeByIndex(r, 1).setText(listGrapeReception[r - 2].date);
      sheet.getRangeByIndex(r, 2).setText(listGrapeReception[r - 2].id);
      sheet.getRangeByIndex(r, 3).setText(listGrapeReception[r - 2].varietal);
      sheet.getRangeByIndex(r, 4).setText(listGrapeReception[r - 2].ranch);
      sheet
          .getRangeByIndex(r, 5)
          .setText(listGrapeReception[r - 2].brix.toString());
      sheet
          .getRangeByIndex(r, 6)
          .setText(listGrapeReception[r - 2].ph.toString());
      sheet
          .getRangeByIndex(r, 7)
          .setText(listGrapeReception[r - 2].kilos.toString());
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final currentDate = DateTime.now();
    String name = '${currentDate.day}${currentDate.month}${currentDate.year}';
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "RECEPCION-UVA-$name.xlsx")
      ..click();
  } catch (e) {}
}
