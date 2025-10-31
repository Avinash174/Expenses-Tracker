import 'package:flutter/material.dart';
import 'package:expense_tracker/expenses.dart';
import 'package:flutter/services.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]).then((_) {
  runApp(MyApp());
  // });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  var KColorScheme = ColorScheme.fromSeed(seedColor: Colors.redAccent);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: KColorScheme,
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: KColorScheme.onPrimaryContainer,
          foregroundColor: KColorScheme.primaryContainer,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          margin: EdgeInsets.all(12),
        ),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: KColorScheme.primaryContainer,
            foregroundColor: KColorScheme.onPrimaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: KColorScheme.onSecondaryContainer,
          ),
        ),
      ),
      home: Expenses(),
    );
  }
}
