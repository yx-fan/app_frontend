import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/inbox_view.dart';
import 'views/signup_step1_view.dart';
import 'views/signup_step2_view.dart';
import 'views/login_view.dart';
import 'views/trip_list_view.dart';
import 'views/map_view.dart';
import 'views/receipt_camera_view.dart';
import 'views/profile_view.dart';
import 'viewmodels/trip_view_model.dart';
import 'viewmodels/trip_expense_view_model.dart'; // 导入 TripExpenseViewModel
import 'services/auth_service.dart';
import 'widgets/navigation.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TripViewModel()),
        ChangeNotifierProvider(create: (_) => TripExpenseViewModel(tripId: 'initialTripId')),
        ChangeNotifierProvider(create: (_) => AuthService()), // 提供 AuthService
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          return MaterialApp(
            title: 'Travel Expense',
            home: authService.isLoggedIn ? MainScreen() : LoginScreen(),
            routes: {
              '/signup_step1': (context) => SignUpStep1View(),
              '/signup_step2': (context) => SignUpStep2View(),
              '/login': (context) => LoginScreen(),
              '/tripView': (context) => MainScreen(),
            },
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    TripListView(),
    StarScreen(), // 假设你有一个 StarScreen 页面
    MapView(tripID: 'all'),
    InboxView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Navigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class StarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Star'),
      ),
      body: Center(
        child: Text('Star Screen'),
      ),
    );
  }
}