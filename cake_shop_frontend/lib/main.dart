import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/app_theme.dart';
import 'src/providers/auth_provider.dart';
import 'src/providers/cake_provider.dart';
import 'src/providers/cart_provider.dart';
import 'src/providers/order_provider.dart';
import 'src/providers/user_provider.dart';
import 'src/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  runApp(const CakeShopApp());
}

/// The main app widget.
/// Sets up providers, theme, and the root navigation.
class CakeShopApp extends StatelessWidget {
  const CakeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CakeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Cake Shop',
            theme: buildDarkTheme(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
