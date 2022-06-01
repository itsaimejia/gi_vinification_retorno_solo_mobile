// ignore_for_file: empty_catches, avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';

import 'package:gi_vinification_retorno/models/fermentation_model.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<void> createExcelFermentations(
    {required List<Fermentation> listFermentations}) async {
  try {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    for (var i = 1; i < Fermentation.titles.length; i++) {
      sheet.getRangeByIndex(1, i).setText(Fermentation.titles[i - 1]);
    }

    for (var r = 2; r < listFermentations.length + 2; r++) {
      sheet.getRangeByIndex(r, 1).setText(listFermentations[r - 2].date);
      sheet.getRangeByIndex(r, 2).setText(listFermentations[r - 2].id);
      sheet.getRangeByIndex(r, 3).setText(listFermentations[r - 2].activity);
      sheet
          .getRangeByIndex(r, 4)
          .setText(listFermentations[r - 2].time.toString());
      sheet.getRangeByIndex(r, 5).setText(listFermentations[r - 2].whoMade);
      sheet
          .getRangeByIndex(r, 6)
          .setText(listFermentations[r - 2].observations);
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final currentDate = DateTime.now();
    String name = '${currentDate.day}${currentDate.month}${currentDate.year}';
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "FERMENTACIONES-$name.xlsx")
      ..click();
  } catch (e) {}
}
