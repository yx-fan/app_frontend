import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/signup_step1_view.dart';
import 'views/signup_step2_view.dart';
import 'views/login_view.dart';
import 'views/trip_list_view.dart';
import 'views/map_view.dart';
import 'views/receipt_camera_view.dart';
import 'views/profile_view.dart';
import 'viewmodels/trip_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TripViewModel())],
      child: MaterialApp(
        title: 'Trip Planner',
        initialRoute: '/signup_step1',
        routes: {
          '/signup_step1': (context) => SignUpStep1View(),
          '/signup_step2': (context) => SignUpStep2View(),
          '/login': (context) => LoginScreen(),
          '/tripView': (context) => TripListView(),
          '/map': (context) => MapView(),
          '/receipt_camera': (context) => ReceiptCameraPage(),
          '/profile': (context) => ProfileView(),
        },
      ),
    );
  }
}
