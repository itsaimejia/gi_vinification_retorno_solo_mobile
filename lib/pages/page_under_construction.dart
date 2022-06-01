import 'package:flutter/material.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Center(
            child: Column(
          children: const [
            Icon(
              Icons.warning,
              color: Colors.yellow,
              size: 50,
            ),
            Text(
              'Página en construccion ',
              style: TextStyle(fontSize: 50),
            )
          ],
        )),
      ),
    );
  }
}
