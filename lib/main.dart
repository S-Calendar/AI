// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'pages/splash_page.dart';
import 'pages/start_page.dart';
import 'pages/main_page.dart';
import 'pages/search_page.dart';
import 'settings_page.dart';
import 'favorite_notices_page.dart';
import 'hidden_items_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCalendar',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(),
        '/main_page': (context) => const MainPage(),
        '/search': (context) => const SearchPage(),
        '/settings': (context) => const SettingsPage(),
        '/favorite': (context) => const FavoriteNoticesPage(),
        '/hidden': (context) => const HiddenItemsPage(),        
      },
    );
  }
}
