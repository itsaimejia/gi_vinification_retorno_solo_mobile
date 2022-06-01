// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/styles/const.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem(
      {Key? key,
      this.height,
      required this.onPressed,
      required this.label,
      this.subSideMenuItems,
      this.labelColor,
      required this.icon,
      this.onTapIconResizable,
      this.isResized,
      required this.color,
      required this.permission})
      : super(key: key);

  final double? height;
  final bool permission;
  final VoidCallback onPressed;
  final VoidCallback? onTapIconResizable;
  final String label;
  final Color? labelColor;
  final List<SubSideMenuItem>? subSideMenuItems;
  final IconData icon;
  final bool? isResized;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return permission
        ? AnimatedContainer(
            margin: const EdgeInsets.only(bottom: 15),
            duration: const Duration(milliseconds: 400),
            curve: Curves.linear,
            width: double.infinity,
            height: height ?? 50,
            decoration: BoxDecoration(color: color),
            alignment: Alignment.topLeft,
            child: ListView(
              children: [
                HeadSideMenuItem(
                  icon: icon,
                  label: label,
                  onPressed: onPressed,
                  onTapIconResizable: onTapIconResizable,
                  isResized: isResized ?? false,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: subSideMenuItems ?? [],
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}

class HeadSideMenuItem extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback? onTapIconResizable;
  final IconData icon;
  final String label;
  final bool? isResized;
  const HeadSideMenuItem(
      {Key? key,
      required this.onPressed,
      this.onTapIconResizable,
      required this.icon,
      required this.label,
      this.isResized})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 9,
              ),
              Expanded(
                child: DefaultTextStyle(
                  child: Text(label),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              onTapIconResizable != null
                  ? Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: onTapIconResizable,
                        icon: Icon(isResized!
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down),
                        color: Colors.white,
                      ),
                    )
                  : const Material()
            ],
          ),
        ),
      ),
    );
  }
}

class SubSideMenuItem extends StatelessWidget {
  VoidCallback onPressed;
  IconData icon;
  String label;

  SubSideMenuItem(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class BottomNavigationBarMultItems extends StatelessWidget {
  final Color? colorItem;
  final String? tooltip;
  final IconData icon;
  final List<PopupMenuEntry> popupsMenuItems;
  final bool permission;
  const BottomNavigationBarMultItems(
      {Key? key,
      this.colorItem,
      this.tooltip,
      required this.icon,
      required this.popupsMenuItems,
      required this.permission})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return permission
        ? Expanded(
            child: PopupMenuButton(
                offset: const Offset(0, -70),
                color: secundaryColor,
                tooltip: 'Fermentaciones',
                child: Icon(icon, size: 20, color: colorItem),
                itemBuilder: ((context) => popupsMenuItems)),
          )
        : Container();
  }
}

class BottomNavigationBarItemCustom extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double? labelFontSize;
  final double? iconSize;
  final Color? colorItem;
  final bool permission;
  const BottomNavigationBarItemCustom(
      {Key? key,
      required this.icon,
      required this.onTap,
      this.iconSize,
      this.labelFontSize,
      required this.permission,
      this.colorItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return permission
        ? Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Icon(
                icon,
                color: colorItem ?? Colors.white,
                size: iconSize ?? 20,
              ),
            ),
          )
        : Container();
  }
}
