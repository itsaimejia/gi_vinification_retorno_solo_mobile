import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/pages/administration/admin_tanks/admin_tanks_page.dart';
import 'package:gi_vinification_retorno/pages/administration/admin_users/admin_users_page.dart';
import 'package:gi_vinification_retorno/pages/administration/admin_varietals/admin_varietals_page.dart';
import 'package:gi_vinification_retorno/styles/const.dart';

class Administration extends StatefulWidget {
  const Administration({Key? key}) : super(key: key);

  @override
  State<Administration> createState() => _AdministrationState();
}

class _AdministrationState extends State<Administration> {
  int index = 0;
  double? fontSize = 18;
  List pages = [
    const AdminUsersPage(),
    const AdminVarietalsPage(),
    const AdminTanksPage()
  ];
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      height: double.infinity,
      child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Row(
                children: [
                  SizedBox(
                    height: 70,
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 0;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: index == 0
                                          ? primaryColor
                                          : backgroundColor,
                                      width: 1),
                                ),
                              ),
                              child: Text(
                                'Usuarios',
                                style: TextStyle(fontSize: fontSize),
                              ),
                            )),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 1;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: index == 1
                                          ? primaryColor
                                          : backgroundColor,
                                      width: 1),
                                ),
                              ),
                              child: Text(
                                'Varietales',
                                style: TextStyle(fontSize: fontSize),
                              ),
                            )),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 2;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: index == 2
                                          ? primaryColor
                                          : backgroundColor,
                                      width: 1),
                                ),
                              ),
                              child: Text(
                                'Tanques',
                                style: TextStyle(fontSize: fontSize),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(child: Container())
                ],
              )
            ]),
            TableRow(children: [
              SizedBox(
                height: mediaQuery.height - 145,
                child: pages[index],
              )
            ])
          ]),
    );
  }
}
