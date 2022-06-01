import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/main.dart';
import 'package:gi_vinification_retorno/models/user_model.dart';
import 'package:gi_vinification_retorno/pages/login_page.dart';
import 'package:gi_vinification_retorno/services/user_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';
import 'package:gi_vinification_retorno/widgets/widgets_forms.dart';
import 'package:provider/provider.dart';

class NewUserPage extends StatefulWidget {
  final String email;
  const NewUserPage({Key? key, required this.email}) : super(key: key);

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final nameController = TextEditingController();
  final secondNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  bool enableToSave = false;
  bool isNotEmailInput = true;

  List<String> roles = ['Analista', 'Enólogo', 'Operador', 'Admin'];

  late DataUserServices userServices;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userServices = Provider.of<DataUserServices>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
        title: const Text('Nuevo usuario'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Material(
          color: backgroundColor,
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 450,
            width: 500,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: secundaryColor, width: 1)),
            child: Form(
              key: _formKey,
              child: Table(
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: SizedBox(
                            height: 50,
                            child: Text(
                              'Información del usuario',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                                width: double.infinity,
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
                            Tooltip(
                              preferBelow: true,
                              message:
                                  'La contraseña debe tener al menos 8 carácteres e incluir al menos: \n*1 mayúscula\n*1 minúscula\n*1 número',
                              child: DataInput(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Ingresa una contraseña';
                                    } else if (value.length < 8) {
                                      return 'Usa minimo 8 carácteres';
                                    } else if (!value.isAPassword) {
                                      return 'Debes incluir al menos: 1 mayúscula, 1 minúscula y 1 número';
                                    }
                                    return null;
                                  },
                                  color: primaryColor,
                                  labelText: 'Contraseña',
                                  controller: passwordController),
                            ),
                            DataInput(
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    return 'Ingresa tu(s) nombre(s)';
                                  } else if (!value.isAName) {
                                    return 'Los números no son validos';
                                  }

                                  return null;
                                }),
                                color: primaryColor,
                                labelText: 'Nombre(s)',
                                controller: nameController),
                            DataInput(
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    return 'Ingresa tu(s) apellido(s)';
                                  } else if (!value.isAName) {
                                    return 'Los números no son validos';
                                  }
                                  return null;
                                }),
                                color: primaryColor,
                                labelText: 'Apellido(s)',
                                controller: secondNameController),
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
                        ClearButton(
                          onPressed: clearForm,
                        ),
                        SaveButton(
                          onPressed: saveUser,
                        ),
                      ],
                    )
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential responseFB = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.value.text.trim(),
                password: passwordController.value.text.trim());
        final user = DataUser(
            uid: responseFB.user!.uid,
            name: nameController.value.text.toCapitalizedEachOne(),
            surnames: secondNameController.value.text.toCapitalizedEachOne(),
            email: emailController.value.text.trim(),
            role: 'Sin rol');
        final response = await userServices.add(user);
        if (response) {
          try {
            final userDecition = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                        titleTextStyle: const TextStyle(fontSize: 20),
                        title: const Text(
                          'Usuario registrado',
                        ),
                        content: const Text.rich(TextSpan(children: [
                          TextSpan(
                            text:
                                'Solicita a tu administrador que te asigne un rol\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            children: [
                              TextSpan(text: 'Presiona '),
                              TextSpan(
                                text: 'Continuar ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text:
                                      'si deseas ingresar al sistema como invitado\n'),
                            ],
                          ),
                          TextSpan(
                            children: [
                              TextSpan(text: 'Presiona '),
                              TextSpan(
                                text: 'Salir ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text:
                                      'si deseas regresar a la pantalla de Inicio\n'),
                            ],
                          )
                        ])),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(
                              'Salir',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Continuar',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ]));
            if (userDecition) {
              await Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (__) => const MainApp()));
            } else {
              await FirebaseAuth.instance.signOut();
              await Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (__) => const LoginPage()));
            }
          } catch (e) {
            await FirebaseAuth.instance.signOut();
            await Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (__) => const LoginPage()));
          }

          clearForm();
        }
      } catch (e) {
        if (e.toString().contains('firebase_auth/email-already-in-use')) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                      titleTextStyle: const TextStyle(fontSize: 20),
                      title: const Text(
                        'Error en el registro',
                      ),
                      content: const Text('Este correo ya está en uso'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Aceptar',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ]));
        }
      }
    }
  }

  void clearForm() {
    setState(() {
      enableToSave = false;
    });
    passwordController.clear();
    nameController.clear();
    secondNameController.clear();
    emailController.clear();
  }
}
