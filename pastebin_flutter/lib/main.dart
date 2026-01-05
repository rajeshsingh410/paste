import 'package:flutter/material.dart';
import 'screens/create_paste.dart';
import 'screens/view_paste.dart';


void main() {
  runApp(const PastebinApp());
}

class PastebinApp extends StatelessWidget {
  const PastebinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pastebin Lite',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '/');

        // Home route "/"
        if (uri.pathSegments.isEmpty) {
          return MaterialPageRoute(
            builder: (_) => CreatePasteScreen(),
          );
        }

        // Paste view route "/p/:id"
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'p') {
          final pasteId = uri.pathSegments[1];

          return MaterialPageRoute(
            builder: (_) => ViewPasteScreen(pasteId: pasteId),
          );
        }

        // 404 route
        return MaterialPageRoute(
          builder: (_) => const NotFoundPage(),
        );
      },
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '404 - Page Not Found',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

