import 'package:flutter/material.dart';

Future<dynamic> showAddForm(
    {required BuildContext context,
    required String date,
    required Widget content}) {
  return showDialog(
      context: context,
      builder: (__) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nuevo registro ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 10),
              )
            ],
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          content: content));
}

Future<dynamic> showEditForm(
    {required BuildContext context, required Widget content}) {
  return showDialog(
      context: context,
      builder: (__) => AlertDialog(
          title: const Text(
            "Editar registro ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          content: content));
}

Future<dynamic> showDeleteForm(
    {required BuildContext context, required Widget content}) {
  return showDialog(
      context: context,
      builder: (__) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.warning, color: Colors.red, size: 15),
              Text(
                "ESTÁS A PUNTO DE ELIMINAR: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.red),
              ),
            ],
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          content: content));
}
