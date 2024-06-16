import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/signup_step1_view.dart';
import 'views/signup_step2_view.dart';
import 'views/login_view.dart';
import 'package:provider/provider.dart';
import 'viewmodels/trip_viewmodel.dart';
import 'views/trip_list_view.dart';
import 'views/map_screen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 216, 151, 86),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
        initialRoute: '/signup_step1',
        routes: {
          '/signup_step1': (context) => SignUpStep1View(),
          '/signup_step2': (context) => SignUpStep2View(),
          '/login': (context) => LoginScreen(),
          '/tripView': (context) => TripListView(),
          '/map': (context) => MapScreen(),
        },
      ),
    );
  }
}

