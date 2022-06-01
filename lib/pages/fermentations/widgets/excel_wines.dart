// ignore_for_file: empty_catches, avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';

import 'package:gi_vinification_retorno/models/wine_model.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<void> createExcelWines({required List<Wine> listWines}) async {
  try {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    for (var i = 1; i < Wine.titles.length; i++) {
      sheet.getRangeByIndex(1, i).setText(Wine.titles[i - 1]);
    }

    for (var r = 2; r < listWines.length + 2; r++) {
      sheet.getRangeByIndex(r, 1).setText(listWines[r - 2].date);
      sheet.getRangeByIndex(r, 2).setText(listWines[r - 2].id);
      sheet.getRangeByIndex(r, 3).setText(listWines[r - 2].type);
      sheet.getRangeByIndex(r, 4).setText(listWines[r - 2].ranch);
      sheet.getRangeByIndex(r, 5).setText(listWines[r - 2].tankName);
      sheet.getRangeByIndex(r, 6).setText(listWines[r - 2].anada);
      sheet.getRangeByIndex(r, 7).setText(listWines[r - 2]
          .blem
          .split(',')
          .map((x) => x.trim().split('-'))
          .map((w) => '${w[0]} ${w[1]}%')
          .join(','));
      sheet.getRangeByIndex(r, 8).setText(listWines[r - 2].liters.toString());
      sheet.getRangeByIndex(r, 9).setText(listWines[r - 2].observations);
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final currentDate = DateTime.now();
    String name = '${currentDate.day}${currentDate.month}${currentDate.year}';
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "VINOS-$name.xlsx")
      ..click();
  } catch (e) {}
}
