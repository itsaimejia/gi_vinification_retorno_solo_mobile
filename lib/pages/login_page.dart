// ignore_for_file: empty_catches, avoid_web_libraries_in_flutter

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/admin/new_user_form.dart';
import 'package:gi_vinification_retorno/pages/home_page.dart';
import 'package:gi_vinification_retorno/services/user_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late DataUserServices userServices;
  String errorMessage = '';
  bool errorLogin = false;
  int buttonIndex = 0;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    userServices = Provider.of<DataUserServices>(context);

    onRecoverPassword() async {
      try {
        final response = await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                    titleTextStyle: const TextStyle(fontSize: 20),
                    title: const Text(
                      'Recuperar contraseña',
                    ),
                    content: SizedBox(
                      height: 50,
                      child: Column(
                        children: [
                          const Text(
                              'Enviaremos un correo para recuperar la contraseña a:'),
                          Text(
                            emailController.value.text,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Aceptar',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ]));
        if (response) {
          try {
            await FirebaseAuth.instance
                .sendPasswordResetEmail(email: emailController.value.text);
          } catch (e) {}
        }
      } catch (e) {}
    }

    Future onLogin() async {
      if (_formKey.currentState!.validate()) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } catch (e) {
          setState(() {
            errorLogin = true;
            if (e.toString().contains('firebase_auth/wrong-password')) {
              errorMessage =
                  'Estás registrado, pero tu contraseña es incorrecta';
              buttonIndex = 1;
            } else if (e.toString().contains('firebase_auth/invalid-email')) {
              errorMessage = 'Revisa que el correo esté bien escrito';
            } else if (e.toString().contains('firebase_auth/user-not-found')) {
              errorMessage = 'Usuario no registrado';
            } else if (e
                .toString()
                .contains('firebase_auth/too-many-requests')) {
              errorMessage =
                  'Se han superado el número de intentos\nPuede restaurarlo inmediatamente restableciendo su contraseña\n O puede volver a intentarlo más tarde';
              buttonIndex = 1;
            }
          });
        }
      }
    }

    return Form(
      key: _formKey,
      child: Container(
        color: backgroundColor,
        alignment: Alignment.center,
        child: Material(
          color: backgroundColor,
          child: Container(
            height: 350,
            width: 300,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Center(
                    child: Text(
                  "Acceso",
                  style: TextStyle(fontSize: 20),
                )),
                Material(
                  elevation: 3,
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailController,
                  onEditingComplete: onLogin,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      focusColor: primaryColor,
                      border: OutlineInputBorder(),
                      hintText: 'Correo',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true),
                  cursorColor: primaryColor,
                  textAlign: TextAlign.center,
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        splashRadius: 1.0,
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      focusColor: primaryColor,
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: 'Contraseña',
                      fillColor: Colors.white,
                      filled: true),
                  textAlign: TextAlign.center,
                  cursorColor: primaryColor,
                  obscureText: !_passwordVisible,
                  onEditingComplete: onLogin,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: errorLogin ? 10 : 0,
                      color: errorLogin ? Colors.red : backgroundColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      errorMessage,
                      style: TextStyle(
                          color: errorLogin ? Colors.red : backgroundColor,
                          fontSize: errorLogin ? 10 : 0),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onLogin,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20), primary: primaryColor),
                  child: const Text("Ingresar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewUserPage(
                                email: emailController.value.text,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20), primary: primaryColor),
                  child: const Text("Registrarte"),
                ),
                if (buttonIndex == 0)
                  Container()
                else if (buttonIndex == 1)
                  ElevatedButton(
                    onPressed: onRecoverPassword,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        primary: primaryColor),
                    child: const Text("Recuperar contraseña"),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
