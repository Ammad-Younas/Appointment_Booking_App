import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:appointment_booking_app/services/theme_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appointment_booking_app/src/views/screens/main_layout_screen.dart';
import 'package:appointment_booking_app/src/views/screens/login_screen.dart';
import 'package:appointment_booking_app/services/notification_service.dart';
import 'firebase_options.dart';
import 'package:app_links/app_links.dart';
import 'package:appointment_booking_app/src/views/screens/update_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeService())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link
    final Uri? initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink);
    }

    // Listen to link stream
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleLink(uri);
      }
    });
  }

  void _handleLink(Uri uri) {
    // Firebase Auth action links look like: https://<project>.firebaseapp.com/__/auth/action?mode=<action>&oobCode=<code>
    final mode = uri.queryParameters['mode'];
    final oobCode = uri.queryParameters['oobCode'];

    if (mode == 'resetPassword' && oobCode != null) {
      // Wait a bit for the app to be ready if it launched from cold start
      Future.delayed(const Duration(seconds: 1), () {
        _navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => UpdatePasswordScreen(oobCode: oobCode)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: themeService.currentThemeData,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasData) {
                // Prevent auto-login if email is not verified (e.g. immediately after sign up)
                if (snapshot.data!.emailVerified) {
                  return const MainLayoutScreen();
                }
                // If not verified, stay on Login Screen (AuthService will sign them out anyway)
                return const LoginScreen();
              }
              return const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
