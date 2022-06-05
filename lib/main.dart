import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/pages/home_page.dart';
import 'package:gi_vinification_retorno/pages/login_page.dart';
import 'package:gi_vinification_retorno/services/analisis_services.dart';
import 'package:gi_vinification_retorno/services/fermentations_services.dart';
import 'package:gi_vinification_retorno/services/grape_reception_services.dart';
import 'package:gi_vinification_retorno/services/tank_services.dart';
import 'package:gi_vinification_retorno/services/user_services.dart';
import 'package:gi_vinification_retorno/services/varietal_services.dart';
import 'package:gi_vinification_retorno/services/wine_services.dart';
import 'package:gi_vinification_retorno/styles/const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//borrar
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AppProvider());
}

class AppProvider extends StatelessWidget {
  const AppProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataUserServices()),
        ChangeNotifierProvider(create: (_) => GrapeReceptionServices()),
        ChangeNotifierProvider(create: (_) => AnalisisServices()),
        ChangeNotifierProvider(create: (_) => FermentationsServices()),
        ChangeNotifierProvider(create: (_) => WineServices()),
        ChangeNotifierProvider(create: (_) => VarietalServices()),
        ChangeNotifierProvider(create: (_) => TankServices())
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GI Vinification',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
            textTheme: GoogleFonts.oxygenTextTheme(Theme.of(context).textTheme),
            tooltipTheme: const TooltipThemeData(
                textStyle: TextStyle(color: Colors.white, fontSize: 10),
                decoration: BoxDecoration(color: primaryColor))),
        home: const MainPage());
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          } else if (snapshot.hasError) {
            showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                      title: Text('Error'),
                      content: Text('Algo salió mal'),
                    ));
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }));
  }
}
