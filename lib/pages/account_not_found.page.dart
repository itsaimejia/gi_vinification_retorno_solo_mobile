import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/pages/login_page.dart';

class AccountNotFound extends StatelessWidget {
  const AccountNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onSingOut() async {
      await FirebaseAuth.instance.signOut();
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (__) => const LoginPage()));
    }

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(
              Icons.warning,
              color: Colors.red,
              size: 50,
            ),
            const Text(
              'No se encontró información de esta cuenta',
              style: TextStyle(fontSize: 50),
            ),
            TextButton(
                onPressed: () => onSingOut(),
                child: const Text('Regresar al inicio'))
          ],
        ),
      ),
    );
  }
}
