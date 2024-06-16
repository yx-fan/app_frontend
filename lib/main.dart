// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'views/signup_step1_view.dart';
// import 'views/signup_step2_view.dart';

// Future<void> main() async {
//   await dotenv.load(fileName: ".env");
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ExpenseTrack',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: '/signup_step1',
//       routes: {
//         '/signup_step1': (context) => SignUpStep1View(),
//         '/signup_step2': (context) => SignUpStep2View(),
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'views/map_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map App',
      home: MapScreen(),
    );
  }
}

