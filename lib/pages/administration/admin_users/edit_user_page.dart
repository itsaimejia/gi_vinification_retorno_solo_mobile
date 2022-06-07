// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/user_model.dart';
import 'package:gi_vinification_retorno/services/user_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';
import 'package:gi_vinification_retorno/widgets/widgets_forms.dart';
import 'package:provider/provider.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final nameController = TextEditingController();
  final secondNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  String? rolValue;
  String? uid;

  bool enableToEdit = false;
  bool isNotUserNameInput = true;
  bool isNotEmailInput = true;

  List<String> roles = ['Analista', 'Enólogo', 'Operador', 'Admin', 'Sin rol'];

  late DataUserServices userServices;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    userServices = Provider.of<DataUserServices>(context);

    return Form(
      key: _formKey,
      child: Table(
        children: [
          const TableRow(
            children: [
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Text(
                    'Consultar por usuario o correo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          TableRow(
            children: [
              Container(
                alignment: Alignment.center,
                child: Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: Column(children: [
                    DataInput(
                        suffixIcon: Tooltip(
                          message: 'Buscar usuario',
                          child: GestureDetector(
                            onTap: onSearch,
                            child: const Icon(
                              Icons.search,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        enabled: !enableToEdit,
                        width: double.infinity,
                        onEditingComplete: mediaWidth > 820 ? onSearch : null,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return 'Ingresa un correo';
                          } else if (!value.isEmail) {
                            return 'Ingresa un correo valido';
                          }

                          return null;
                        }),
                        color: primaryColor,
                        labelText: 'Correo',
                        controller: emailController),
                    DataInput(
                        validator: ((value) {
                          if (enableToEdit && isNotEmailInput) {
                            if (value!.isEmpty) {
                              return 'Ingresa tu(s) nombre(s)';
                            } else if (!value.isAName) {
                              return 'Los números no son validos';
                            }
                          }

                          return null;
                        }),
                        enabled: enableToEdit,
                        color: primaryColor,
                        labelText: 'Nombre(s)',
                        controller: nameController),
                    DataInput(
                        validator: ((value) {
                          if (enableToEdit && isNotEmailInput) {
                            if (value!.isEmpty) {
                              return 'Ingresa tu(s) apellido(s)';
                            } else if (!value.isAName) {
                              return 'Los números no son validos';
                            }
                          }
                          return null;
                        }),
                        enabled: enableToEdit,
                        color: primaryColor,
                        labelText: 'Apellido(s)',
                        controller: secondNameController),
                    DropdownButtonForm(
                        validator: ((value) {
                          if (enableToEdit && isNotEmailInput) {
                            if (rolValue == null) {
                              return 'Selecciona un rol';
                            }
                          }
                          return null;
                        }),
                        onChanged: (String? value) {
                          setState(() => rolValue = value);
                        },
                        enabled: enableToEdit,
                        hintText: 'Rol',
                        value: rolValue,
                        items: roles),
                  ]),
                ),
              ),
            ],
          ),
          TableRow(children: [
            Container(
              height: 20,
            )
          ]),
          TableRow(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IgnorePointer(
                  ignoring: !enableToEdit,
                  child: ClearButton(
                    onPressed: clearForm,
                    isDisabled: !enableToEdit,
                  ),
                ),
                IgnorePointer(
                  ignoring: !enableToEdit,
                  child: SaveButton(
                    color: Colors.blue,
                    onPressed: editUser,
                    isDisabled: !enableToEdit,
                  ),
                ),
              ],
            )
          ])
        ],
      ),
    );
  }

  void clearForm() {
    setState(() {
      enableToEdit = false;
      rolValue = null;
    });
    userNameController.text = '';
    passwordController.text = '';
    nameController.text = '';
    secondNameController.text = '';
    emailController.text = '';
  }

  void editUser() async {
    if (_formKey.currentState!.validate()) {
      final user = DataUser(
          email: emailController.text,
          uid: uid,
          name: nameController.value.text.toCapitalizedEachOne(),
          surnames: secondNameController.value.text.toCapitalizedEachOne(),
          role: rolValue!);
      final response = await userServices.update(user);

      if (response) {
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  titleTextStyle: TextStyle(fontSize: 20),
                  title: Text(
                    'Cambios guardados',
                  ),
                ));
        clearForm();
      }
    }
  }

  void onSearch() async {
    setState(() {
      isNotEmailInput = false;
    });
    try {
      if (_formKey.currentState!.validate()) {
        final email = emailController.value.text.trim();
        await userServices.getByEmail(email).then(
          (value) {
            if (value == null) {
              showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                        titleTextStyle: TextStyle(fontSize: 20),
                        title: Text(
                          'No existe el usuario',
                        ),
                        content: Text(
                            'No se encontró resgitro con este correo\nPrueba con uno diferente'),
                      ));
            } else {
              setState(() {
                enableToEdit = true;
                rolValue = value.role!;
                uid = value.uid;
              });
              nameController.text = value.name!;
              secondNameController.text = value.surnames!;
            }
          },
        );
      }
    } catch (e) {}
    setState(() {
      isNotEmailInput = true;
    });
  }
}
