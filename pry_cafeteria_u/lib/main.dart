import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/producto_viewmodel.dart';
import 'viewmodels/pedido_viewmodel.dart';
import 'views/splash_screen.dart';
import 'temas/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductoViewModel()),
        ChangeNotifierProvider(create: (_) => PedidoViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafetería Universitaria',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
