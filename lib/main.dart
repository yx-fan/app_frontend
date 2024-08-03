import 'package:app_frontend/viewmodels/currency_view_model.dart';
import 'package:app_frontend/viewmodels/star_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'views/inbox_view.dart';
import 'views/signup_step1_view.dart';
import 'views/signup_step2_view.dart';
import 'views/login_view.dart';
import 'views/trip_list_view.dart';
import 'views/map_view.dart';
import 'views/star_view.dart';
import 'views/profile_view.dart';
import 'viewmodels/trip_view_model.dart';
import 'viewmodels/trip_expense_view_model.dart'; // Import TripExpenseViewModel
import 'services/auth_service.dart';
import 'widgets/navigation.dart';
import 'viewmodels/signup_view_model.dart'; // Import SignUpViewModel

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TripViewModel()),
        ChangeNotifierProvider(create: (_) => TripExpenseViewModel()),
        ChangeNotifierProvider(create: (_) => CurrencyViewModel()),
        ChangeNotifierProvider(create: (_) => StarViewModel()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()), // Add SignUpViewModel
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          return MaterialApp(
            title: 'Travel Expense',
            theme: ThemeData(
              primarySwatch: Colors.orange,
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
              ),
            ),
            home: authService.isLoggedIn ? const MainScreen() : const LoginScreen(),
            routes: {
              '/signup_step1': (context) => const SignUpStep1View(),
              '/signup_step2': (context) => const SignUpStep2View(),
              '/login': (context) => const LoginScreen(),
              '/tripView': (context) => const MainScreen(),
            },
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const TripListView(),
    const StarScreen(), // Assume you have a StarScreen page
    const MapView(),
    const InboxView(),
    const ProfileView(),
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
