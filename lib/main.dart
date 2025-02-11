import 'package:flutter/material.dart';
import 'screens/setup_screen.dart';
import 'screens/test_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Rephraser',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        primaryColor: const Color(0xFF00FF9C),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color(0xFF00FF9C),
          secondary: const Color(0xFF00D1FF),
          surface: const Color(0xFF1D1F3E),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1D1F3E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: Color(0xFF00FF9C),
              width: 1,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1D1F3E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF00FF9C)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF00FF9C)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF00D1FF), width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00FF9C),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF00FF9C),
          ),
        ),
      ),
      routes: {
        '/': (context) => FutureBuilder<bool>(
              future: StorageService.hasApiKey(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00FF9C),
                      ),
                    ),
                  );
                }
                return snapshot.data == true
                    ? const TestScreen()
                    : const SetupScreen();
              },
            ),
        '/setup': (context) => const SetupScreen(),
        '/test': (context) => const TestScreen(),
      },
    );
  }
}