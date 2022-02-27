import 'package:flutter/material.dart';
import 'package:poms/injection.dart';
import 'package:poms/screens/redirect_screen.dart';
import 'route_generator.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RedirectScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
