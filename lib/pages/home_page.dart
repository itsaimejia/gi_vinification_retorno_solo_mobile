// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:gi_vinification_retorno/bundle.dart';
import 'package:gi_vinification_retorno/models/globals.dart';
import 'package:gi_vinification_retorno/models/user_model.dart';
import 'package:gi_vinification_retorno/pages/dashboard/dashboard_page.dart';
import 'package:gi_vinification_retorno/pages/account_not_found.page.dart';
import 'package:gi_vinification_retorno/pages/login_page.dart';
import 'package:gi_vinification_retorno/services/user_services.dart';

import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:gi_vinification_retorno/widgets/widgets_pages.dart';
import 'package:gi_vinification_retorno/widgets/widgets_menu.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DataUser dataUser;
  int indexPage = 0;
  bool reSize = false;

  Map pages = {
    0: {'title': 'Dashboard', 'page': DashboardPage()},
    1: {'title': 'Recepción Uva', 'page': const GrapeReceptionPage()},
    2: {'title': 'Análisis', 'page': const AnalisisPage()},
    3: {'title': 'Fermentaciones', 'page': const FermentationsPage()},
    4: {'title': 'Vino', 'page': const WinePage()},
    5: {'title': 'Módulo de Administración ', 'page': const Administration()},
  };

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final dataUserServices = Provider.of<DataUserServices>(context);
    var mediaQuerySize = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: dataUserServices.get(user!.uid),
        builder: ((context, snapshot) {
          if (snapshot.data == null) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const AccountNotFound();
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.red),
              );
            }
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else {
            dataUser = snapshot.data as DataUser;

            return mediaQuerySize > 820
                ? buildHomePagePC()
                : buildHomePageMobile();
          }
        }));
  }

  void onSingOut() async {
    await FirebaseAuth.instance.signOut();
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (__) => const LoginPage()));
  }

  buildHomePagePC() {
    Globals.setUserName(dataUser.name);
    Globals.setUserSurnames(dataUser.surnames);
    Globals.setUserRole(dataUser.role);
    return Row(children: [
      Container(
        height: double.infinity,
        width: 230,
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Container(
              height: 150,
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              width: double.infinity,
              child: SvgPicture.asset('assets/logoBlanco.svg'),
            ),
            SideMenuItem(
              permission: true,
              label: "Dashboard",
              icon: Icons.dashboard,
              labelColor: Colors.white,
              color: indexPage != 0 ? primaryColor : secundaryColor,
              onPressed: () {
                setState(() {
                  indexPage = 0;
                  reSize = false;
                });
              },
            ),
            SideMenuItem(
              permission: dataUser.role != 'Sin rol',
              label: "Recepción Uva",
              icon: Icons.receipt,
              labelColor: Colors.white,
              color: indexPage != 1 ? primaryColor : secundaryColor,
              onPressed: () {
                setState(() {
                  indexPage = 1;
                  reSize = false;
                });
              },
            ),
            SideMenuItem(
              permission:
                  dataUser.role != 'Operador' && dataUser.role != 'Sin rol',
              label: "Análisis",
              icon: Icons.assignment,
              labelColor: Colors.white,
              color: indexPage != 2 ? primaryColor : secundaryColor,
              onPressed: () {
                setState(() {
                  indexPage = 2;
                  reSize = false;
                });
              },
            ),
            SideMenuItem(
              permission:
                  dataUser.role != 'Analista' && dataUser.role != 'Sin rol',
              label: "Fermentaciones",
              icon: Icons.wine_bar,
              labelColor: Colors.white,
              height: reSize ? 100 : 50,
              color: indexPage == 3 || indexPage == 4 || reSize
                  ? secundaryColor
                  : primaryColor,
              isResized: reSize,
              onTapIconResizable: () {
                if (reSize) {
                  setState(() {
                    reSize = false;
                  });
                } else {
                  setState(() {
                    reSize = true;
                  });
                }
              },
              subSideMenuItems: [
                SubSideMenuItem(
                    onPressed: () {
                      setState(() {
                        indexPage = 4;
                      });
                    },
                    icon: Icons.wine_bar,
                    label: "Vino"),
              ],
              onPressed: () {
                setState(() {
                  indexPage = 3;
                });
              },
            ),
            const Spacer(),
            SideMenuItem(
              permission: dataUser.role == 'Admin',
              label: "Administrar",
              icon: Icons.settings,
              labelColor: Colors.white,
              color: indexPage != 5 ? primaryColor : secundaryColor,
              onPressed: () {
                setState(() {
                  indexPage = 5;
                  reSize = false;
                });
              },
            )
          ]),
        ),
      ),
      Expanded(
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 1,
              backgroundColor: primaryColor,
              title: Center(child: Text(pages[indexPage]['title'])),
              actions: [
                ActionsUserButton(
                  name: dataUser.name,
                  popupsMenuItems: [
                    PopupMenuItem(
                        height: 20,
                        onTap: onSingOut,
                        child: const Text(
                          "Salir",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ))
                  ],
                )
              ]),
          body: Container(
              color: backgroundColor, child: pages[indexPage]['page']),
        ),
      ),
    ]);
  }

  buildHomePageMobile() {
    Globals.setUserName(dataUser.name);
    Globals.setUserSurnames(dataUser.surnames);
    Globals.setUserRole(dataUser.role);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          backgroundColor: primaryColor,
          title: Text(pages[indexPage]['title']),
          actions: [
            ActionsUserButton(name: dataUser.name, popupsMenuItems: [
              if (dataUser.role == 'Admin')
                PopupMenuItem(
                    height: 40,
                    onTap: () => setState(() => indexPage = 5),
                    child: const Text(
                      "Administrar",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
              PopupMenuItem(
                  height: 40,
                  onTap: onSingOut,
                  child: const Text(
                    "Salir",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )),
            ])
          ]),
      body: Container(color: backgroundColor, child: pages[indexPage]['page']),
      bottomNavigationBar: Container(
        height: 55,
        padding: const EdgeInsets.only(bottom: 4),
        color: primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomNavigationBarItemCustom(
              permission: true,
              colorItem: indexPage == 0 ? Colors.white : secundaryColor,
              onTap: () => setState(() => indexPage = 0),
              icon: Icons.dashboard,
            ),
            BottomNavigationBarItemCustom(
              permission: dataUser.role != 'Sin rol',
              colorItem: indexPage == 1 ? Colors.white : secundaryColor,
              onTap: () => setState(() => indexPage = 1),
              icon: Icons.receipt,
            ),
            BottomNavigationBarItemCustom(
              permission: dataUser.role == 'Admin' ||
                  dataUser.role == 'Enólogo' ||
                  dataUser.role == 'Analista',
              colorItem: indexPage == 2 ? Colors.white : secundaryColor,
              icon: Icons.assignment,
              onTap: () => setState(() => indexPage = 2),
            ),
            BottomNavigationBarMultItems(
              permission: dataUser.role == 'Admin' ||
                  dataUser.role == 'Enólogo' ||
                  dataUser.role == 'Operador',
              popupsMenuItems: [
                PopupMenuItem(
                    height: 20,
                    onTap: () => setState(() => indexPage = 3),
                    child: const Text(
                      "Fermentaciones",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
                PopupMenuItem(
                    height: 20,
                    onTap: () => setState(() => indexPage = 4),
                    child: const Text(
                      "Vino",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
              ],
              icon: Icons.wine_bar,
              colorItem: indexPage == 3 || indexPage == 4
                  ? Colors.white
                  : secundaryColor,
            )
          ],
        ),
      ),
    );
  }
}
