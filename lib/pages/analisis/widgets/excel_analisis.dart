// ignore_for_file: avoid_web_libraries_in_flutter, empty_catches

import 'dart:convert';
import 'dart:html';
import 'package:gi_vinification_retorno/models/analisis_model.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<void> createExcelAnalisis({required List<Analisis> listAnalisis}) async {
  try {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    for (var i = 1; i < Analisis.titles.length; i++) {
      sheet.getRangeByIndex(1, i).setText(Analisis.titles[i - 1]);
    }

    for (var r = 2; r < listAnalisis.length + 2; r++) {
      sheet.getRangeByIndex(r, 1).setText(listAnalisis[r - 2].date);
      sheet.getRangeByIndex(r, 2).setText(listAnalisis[r - 2].id);
      sheet.getRangeByIndex(r, 3).setText(listAnalisis[r - 2].type);
      sheet.getRangeByIndex(r, 4).setText(listAnalisis[r - 2].brix.toString());
      sheet.getRangeByIndex(r, 5).setText(listAnalisis[r - 2].ph.toString());
      sheet
          .getRangeByIndex(r, 6)
          .setText(listAnalisis[r - 2].analysisPerformed);

      sheet.getRangeByIndex(r, 7).setText(listAnalisis[r - 2].observations);
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final currentDate = DateTime.now();
    String name = '${currentDate.day}${currentDate.month}${currentDate.year}';
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "ANALISIS-$name.xlsx")
      ..click();
  } catch (e) {}
}
