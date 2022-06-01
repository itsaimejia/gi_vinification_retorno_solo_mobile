import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/pages/administration/admin_users/edit_user_page.dart';
import 'package:gi_vinification_retorno/pages/administration/admin_users/delete_user_page.dart';
import 'package:gi_vinification_retorno/services/user_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:provider/provider.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({Key? key}) : super(key: key);

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  late DataUserServices userServices;
  int index = 0;
  List pages = [const EditUserPage(), const DeleteUserPage()];
  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    userServices = Provider.of<DataUserServices>(context);
    return Container(
      alignment: mediaWidth > 820 ? Alignment.center : Alignment.topCenter,
      child: Material(
          color: backgroundColor,
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 550,
            width: 500,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: secundaryColor, width: 1)),
            child: Table(
              children: [
                const TableRow(
                  children: [
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          'Acciones usuarios ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                TableRow(children: [
                  Container(
                    height: 10,
                  )
                ]),
                TableRow(children: [
                  Row(
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
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                              color: index == 0 ? Colors.blue : backgroundColor,
                            ),
                            child: const Text(
                              'Editar',
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
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: index == 1
                                        ? Colors.red
                                        : backgroundColor,
                                    width: 1),
                              ),
                            ),
                            child: const Text(
                              'Eliminar',
                            ),
                          ))
                    ],
                  )
                ]),
                TableRow(children: [
                  Container(
                    height: 20,
                  )
                ]),
                TableRow(children: [pages[index]])
              ],
            ),
          )),
    );
  }
}
