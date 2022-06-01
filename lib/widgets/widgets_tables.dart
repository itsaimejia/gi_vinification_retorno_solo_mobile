import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/styles/const.dart';

class ActionsIndexTable extends StatelessWidget {
  final VoidCallback onEdited;
  final VoidCallback onDeleted;
  final VoidCallback onViewResponsible;
  final bool enabled;
  final String? userType;
  final double? iconSize;
  const ActionsIndexTable(
      {Key? key,
      required this.onEdited,
      required this.onDeleted,
      required this.enabled,
      required this.onViewResponsible,
      this.userType,
      this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: enabled ? onEdited : null,
          child: Tooltip(
            message: 'Editar',
            child: Icon(
              Icons.edit,
              color: enabled ? Colors.blue : Colors.grey.shade800,
              size: iconSize ?? 25,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        if (userType == 'Admin')
          GestureDetector(
            onTap: enabled ? onDeleted : null,
            child: Tooltip(
              message: 'Eliminar',
              child: Icon(
                Icons.remove,
                color: enabled ? Colors.red : Colors.grey.shade800,
                size: iconSize ?? 25,
              ),
            ),
          ),
        const SizedBox(
          width: 5,
        ),
        if (userType == 'Admin')
          GestureDetector(
            onTap: enabled ? onViewResponsible : null,
            child: Tooltip(
              message: 'Responsable',
              child: Icon(
                Icons.remove_red_eye_outlined,
                color: enabled ? Colors.black : Colors.grey.shade800,
                size: iconSize ?? 25,
              ),
            ),
          )
      ],
    );
  }
}

class ButtonShowObservation extends StatelessWidget {
  final String observations;
  const ButtonShowObservation({Key? key, required this.observations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthPage = MediaQuery.of(context).size.width;
    void onShow() async {
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Observaciones'),
                content: SizedBox(
                  width: 150,
                  child: Text(observations),
                ),
              ));
    }

    if (widthPage > 820) {
      return ElevatedButton.icon(
          onPressed: onShow,
          style: ElevatedButton.styleFrom(primary: primaryColor),
          icon: const Icon(
            Icons.read_more,
            size: 20,
          ),
          label: const Text(
            'Observaciones',
            style: TextStyle(fontSize: 13),
          ));
    } else {
      return Center(
        child: IconButton(
            onPressed: onShow,
            icon: const Icon(
              Icons.read_more,
              color: primaryColor,
              size: 20,
            )),
      );
    }
  }
}
