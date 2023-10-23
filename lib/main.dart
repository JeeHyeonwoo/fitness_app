import 'package:fitnessapp/routes.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/counting/counting_controller.dart';
import 'package:fitnessapp/utils/db/db_init.dart';
import 'package:fitnessapp/utils/timer/timer_view_model.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async{
  await initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DatabaseInit().initDB();
    return MaterialApp(
      title: 'fitness',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ko', '')
      ],
      debugShowCheckedModeBanner: false,
      routes: routes,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor1,
        useMaterial3: true,
        fontFamily: "Poppins"
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<TimerViewModel>(
            create: (context) => TimerViewModel(),
          ),
          ChangeNotifierProvider<CountingController>(
            create: (context) => CountingController(),
          ),
        ],
        child: const DashboardScreen(),
      )
    );
  }
}

