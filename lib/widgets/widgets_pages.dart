import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/styles/const.dart';

class ExcelButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ExcelButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10), primary: const Color(0xFF16854B)),
      child: Row(
        children: const [
          Icon(Icons.file_download),
          SizedBox(
            width: 5,
          ),
          Text("Excel")
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final VoidCallback onTap;
  final Function(PointerEnterEvent)? onEnter;
  final Function(PointerExitEvent)? onExit;
  final bool isMouseEnter;
  const AddButton(
      {Key? key,
      required this.onTap,
      required this.onEnter,
      required this.onExit,
      required this.isMouseEnter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 5,
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          onEnter: onEnter,
          onExit: onExit,
          child: AnimatedContainer(
            width: isMouseEnter ? 100 : 30,
            height: 45,
            decoration: BoxDecoration(
              color: isMouseEnter ? Colors.green : Colors.green.shade300,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 0,
                style: BorderStyle.solid,
                color: isMouseEnter ? Colors.green : Colors.green.shade300,
              ),
            ),
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: Stack(
              children: const [
                Positioned(
                  left: 3,
                  top: 10,
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                Positioned(
                    left: 30,
                    top: 11,
                    child: Text(
                      'Agregar',
                      style: TextStyle(fontSize: 17),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputSearch extends StatelessWidget {
  final void Function(String value) onSubmitted;
  final TextEditingController controller;
  final String labelText;
  final double? maxWidth;
  final String tooltipMessage;
  final void Function()? onTap;
  final bool sizableState;
  final IconData? iconData;
  final double? fontSize;
  final double? iconSize;
  const InputSearch(
      {Key? key,
      required this.onSubmitted,
      required this.controller,
      required this.labelText,
      this.maxWidth,
      required this.tooltipMessage,
      this.onTap,
      required this.sizableState,
      this.iconData,
      this.iconSize,
      this.fontSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        height: 55,
        width: sizableState ? maxWidth ?? 100 : 27,
        child: Tooltip(
          message: tooltipMessage,
          child: TextField(
            onTap: onTap,
            controller: controller,
            onSubmitted: onSubmitted,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle:
                  TextStyle(color: primaryColor, fontSize: fontSize ?? 15),
              prefixIcon: Icon(
                iconData ?? Icons.search,
                color: primaryColor,
                size: iconSize ?? 23,
              ),
              focusColor: primaryColor,
              iconColor: primaryColor,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: secundaryColor),
              ),
            ),
          ),
        ));
  }
}

class InputDate extends StatelessWidget {
  final String labelText;
  final void Function() onTap;
  final bool sizableState;
  final double? maxWidth;
  final double? fontSize;
  final double? iconSize;
  const InputDate(
      {Key? key,
      required this.labelText,
      required this.onTap,
      this.maxWidth,
      this.fontSize,
      this.iconSize,
      required this.sizableState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        height: 55,
        width: sizableState ? maxWidth ?? 120 : 27,
        child: Tooltip(
          message: 'Filtrar por fecha',
          child: TextField(
            decoration: InputDecoration(
              labelText: labelText.isEmpty ? "Fecha" : labelText,
              labelStyle:
                  TextStyle(color: primaryColor, fontSize: fontSize ?? 15),
              prefixIcon: Icon(
                Icons.calendar_today,
                color: primaryColor,
                size: iconSize ?? 23,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: secundaryColor),
              ),
            ),
            onTap: onTap,
          ),
        ));
  }
}

class ActionsUserButton extends StatelessWidget {
  final String name;
  final List<PopupMenuEntry> popupsMenuItems;
  const ActionsUserButton(
      {Key? key, required this.popupsMenuItems, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: PopupMenuButton(
          tooltip: 'Acciones de usuario',
          color: const Color(0xFF666666),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name),
              const SizedBox(
                width: 5,
              ),
              const Icon(Icons.person)
            ],
          ),
          itemBuilder: ((context) => popupsMenuItems)),
    );
  }
}

class ClearFiltersButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? size;
  const ClearFiltersButton({Key? key, required this.onPressed, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Limpiar busquedas',
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            Icons.cleaning_services_sharp,
            size: size ?? 20,
            color: Colors.grey,
          )),
    );
  }
}

Future getDate(BuildContext context) async {
  try {
    DateTime date = DateTime(1900);
    FocusScope.of(context).requestFocus(FocusNode());

    date = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
                primary: primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
                background: secundaryColor),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  primary: primaryColor // button text color
                  ),
            ),
          ),
          child: child!,
        );
      },
    ))!;

    return "${date.day}/${date.month}/${date.year}";
  } catch (e) {
    return null;
  }
}
