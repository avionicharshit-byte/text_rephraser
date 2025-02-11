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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => FutureBuilder<bool>(
              future: StorageService.hasApiKey(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
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