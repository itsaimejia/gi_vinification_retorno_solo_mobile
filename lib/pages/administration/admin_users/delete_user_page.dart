// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/services/user_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';
import 'package:gi_vinification_retorno/widgets/widgets_forms.dart';
import 'package:provider/provider.dart';

class DeleteUserPage extends StatefulWidget {
  const DeleteUserPage({Key? key}) : super(key: key);

  @override
  State<DeleteUserPage> createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final inputController = TextEditingController();
  final confirmController = TextEditingController();
  late DataUserServices userServices;
  final _formKey = GlobalKey<FormState>();

  String uid = '';
  String completeName = '';
  String email = '';
  String rol = '';

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    userServices = Provider.of<DataUserServices>(context);
    return Form(
      key: _formKey,
      child: Table(
        children: [
          TableRow(children: [
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: Tooltip(
                    preferBelow: true,
                    message: 'Correo',
                    child: DataInput(
                      icon: mediaWidth > 820 ? Icons.search : null,
                      color: primaryColor,
                      labelText: 'Correo',
                      controller: inputController,
                      onEditingComplete: mediaWidth > 820 ? byEmail : null,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo vacío';
                        } else if (!value.isEmail) {
                          return 'Ingresa un correo válido';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                if (mediaWidth < 820)
                  Tooltip(
                    message: 'Validar usuario',
                    child: GestureDetector(
                        onTap: byEmail,
                        child: const Material(
                          color: backgroundColor,
                          elevation: 2,
                          child: Icon(Icons.search),
                        )),
                  ),
              ],
            )),
          ]),
          TableRow(children: [
            Column(
              children: [
                LabelInfo(
                  label: 'Correo',
                  value: email,
                ),
                LabelInfo(
                  label: 'Nombre completo',
                  value: completeName,
                ),
                LabelInfo(
                  label: 'Rol',
                  value: rol,
                ),
                const SizedBox(
                  height: 20,
                ),
                DeleteButton(
                    label: 'Eliminar',
                    onPressed: uid.isNotEmpty ? onDelete : null)
              ],
            )
          ])
        ],
      ),
    );
  }

  void onDelete() async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: const Text('Confirmar'),
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.red.shade200,
                      child: Text.rich(TextSpan(children: [
                        const TextSpan(
                          text:
                              'Esta acción elimina permanentemente la cuenta del usuario, pero NO por completo el acceso\nPara eliminar por completo al usuario contacte a su administrador\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          children: [
                            const TextSpan(text: 'Escribe '),
                            TextSpan(
                              text: inputController.value.text,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: ' y selecciona '),
                            const TextSpan(
                              text: 'Confirmar ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: 'para eliminar el usuario '),
                          ],
                        ),
                      ]))),
                  DataInput(
                      width: 200,
                      labelText: inputController.value.text,
                      controller: confirmController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (confirmController.value.text.trim() ==
                              inputController.value.text) {
                            await userServices.delete(uid);
                            inputController.clear();
                            setState(() {
                              uid = '';
                              completeName = '';
                              email = '';
                              rol = '';
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }

  void byEmail() async {
    try {
      final input = inputController.value.text;
      if (_formKey.currentState!.validate()) {
        await userServices.getByEmail(input).then(
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
                rol = value.role!;
                completeName = '${value.name!} ${value.surnames!}';
                uid = value.uid;
                email = value.email!;
              });
            }
          },
        );
      }
    } catch (e) {}
  }
}
