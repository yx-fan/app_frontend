import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/trip_viewmodel.dart';
import 'views/trip_list_view.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 216, 151, 86),
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TripViewModel(),
      child: MaterialApp(
        title: 'Trip Planner',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color.fromARGB(194, 241, 147, 6), // Button background color
              foregroundColor: Colors.white, // Button text color
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        home: TripListView(),
      ),
    );
  }
}
