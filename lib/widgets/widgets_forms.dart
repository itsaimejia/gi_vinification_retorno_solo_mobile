// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/styles/const.dart';

class DataInput extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final VoidCallback? onEditingComplete;
  final bool? obscureText;
  final double? height;
  final double? width;
  final Color? color;
  final bool? enabled;
  final TextInputType? keyboardType;
  final IconData? icon;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onSaved;
  final int? maxLines;
  final double? fontSize;
  final Widget? suffixIcon;

  const DataInput(
      {Key? key,
      required this.labelText,
      this.suffixIcon,
      this.controller,
      this.onEditingComplete,
      this.onSaved,
      this.obscureText,
      this.height,
      this.width,
      this.color,
      this.enabled,
      this.keyboardType,
      this.icon,
      this.validator,
      this.fontSize,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      height: height ?? 70,
      width: width ?? double.infinity,
      child: TextFormField(
        onSaved: onSaved,
        maxLines: maxLines ?? 1,
        validator: validator,
        keyboardType: keyboardType,
        enabled: enabled,
        onEditingComplete: onEditingComplete,
        controller: controller,
        obscureText: obscureText ?? false,
        cursorColor: color ?? secundaryColor,
        style: TextStyle(fontSize: fontSize ?? 15),
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  size: 20,
                  color: color ?? primaryColor,
                )
              : null,
          errorStyle: const TextStyle(fontSize: 10, color: Colors.red),
          prefixIconColor: getColor(),
          iconColor: getColor(),
          focusColor: getColor(),
          labelText: labelText,
          labelStyle: TextStyle(color: getColor()),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: backgroundColor,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: color ?? primaryColor,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: secundaryColor),
          ),
        ),
      ),
    );
  }

  Color getColor() {
    return enabled == null
        ? color ?? primaryColor
        : enabled!
            ? color ?? primaryColor
            : Colors.grey;
  }
}

class DropdownButtonForm extends StatelessWidget {
  final bool? enabled;
  final String? value;
  final String hintText;
  final List<String> items;
  final void Function(String? value)? onChanged;
  final String? Function(String? value)? validator;
  final double? height;
  final Color? color;
  final double? width;

  const DropdownButtonForm(
      {Key? key,
      this.enabled,
      this.height,
      this.color,
      this.width,
      required this.value,
      required this.hintText,
      required this.items,
      required this.onChanged,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: enabled == null ? false : !enabled!,
      child: Container(
        height: height ?? 65,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: DropdownButtonFormField(
          dropdownColor: Colors.grey.shade300,
          elevation: 0,
          menuMaxHeight: 200,
          validator: validator,
          value: value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(item),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          focusColor: Colors.transparent,
          decoration: InputDecoration(
            errorStyle: const TextStyle(fontSize: 10, color: Colors.red),
            enabled: enabled == null ? true : enabled!,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: color ?? primaryColor,
              ),
            ),
            disabledBorder: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: color ?? primaryColor,
              ),
            ),
            labelStyle: const TextStyle(fontSize: 14),
            hintStyle: TextStyle(
                fontSize: 15,
                color: enabled == null
                    ? color ?? primaryColor
                    : enabled!
                        ? color ?? primaryColor
                        : Colors.grey),
            focusColor: color ?? primaryColor,
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final void Function() onPressed;
  final bool? isDisabled;
  final Color? color;
  const SaveButton(
      {Key? key, required this.onPressed, this.isDisabled, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        hoverColor: Colors.transparent,
        splashRadius: 1,
        tooltip: 'Guardar',
        onPressed: isDisabled == null
            ? onPressed
            : (isDisabled == true)
                ? null
                : onPressed,
        icon: Icon(
          Icons.save,
          color: color ?? Colors.green,
        ));
  }
}

class CancelButton extends StatelessWidget {
  final void Function() onPressed;
  const CancelButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        hoverColor: Colors.transparent,
        splashRadius: 1,
        tooltip: 'Cancelar',
        onPressed: onPressed,
        icon: const Icon(
          Icons.cancel,
          color: Colors.red,
        ));
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const DeleteButton({Key? key, required this.onPressed, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: onPressed,
        icon: const Icon(
          Icons.delete,
        ),
        label: Text(label));
  }
}

class SecondaryDeleteButton extends StatelessWidget {
  final void Function() onPressed;
  const SecondaryDeleteButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(primary: Colors.white),
        onPressed: onPressed,
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        label: const Text(
          'Solo registro',
          style: TextStyle(color: Colors.red),
        ));
  }
}

class ClearButton extends StatelessWidget {
  final void Function() onPressed;
  final bool? isDisabled;
  const ClearButton({Key? key, required this.onPressed, this.isDisabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: isDisabled == null
            ? onPressed
            : (isDisabled == true)
                ? null
                : onPressed,
        icon: Icon(
          Icons.cleaning_services_rounded,
          color: Colors.grey.shade600,
        ));
  }
}

class LabelInfo extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? style;
  const LabelInfo(
      {Key? key, required this.label, required this.value, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          alignment: Alignment.centerRight,
          child: Text(
            '$label :',
            style: style,
          ),
        )),
        const SizedBox(width: 15),
        Expanded(
            child: Container(
          alignment: Alignment.centerLeft,
          child: Text(value, style: style),
        ))
      ],
    );
  }
}

class CheckBoxCustom extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final String label;
  final bool enable;
  const CheckBoxCustom(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.label,
      required this.enable})
      : super(key: key);

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return secundaryColor;
    } else if (!enable) {
      return Colors.grey;
    }
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: enable ? onChanged : null,
          fillColor: MaterialStateProperty.resolveWith(getColor),
        ),
        Text(
          label,
          style: const TextStyle(color: primaryColor),
        )
      ],
    );
  }
}

class HelpTooltip extends StatelessWidget {
  final String message;

  HelpTooltip({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: const Icon(Icons.help),
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
