import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/signup_step1_view.dart';
import 'views/signup_step2_view.dart';
import 'views/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpenseTrack',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/signup_step1',
      routes: {
        '/signup_step1': (context) => SignUpStep1View(),
        '/signup_step2': (context) => SignUpStep2View(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
