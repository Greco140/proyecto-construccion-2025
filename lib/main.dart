import 'package:dynadoc_front/network/jwt_key.dart';
import 'package:dynadoc_front/routes.dart';
import 'package:dynadoc_front/viewmodels/dashboard_view_model.dart';
import 'package:dynadoc_front/viewmodels/login_view_model.dart';
import 'package:dynadoc_front/views/Login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JwtKey().loadToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
      ],
      child: MaterialApp(
        title: 'DynaDocs',
        routes: appRoutes,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Loginview(),
      ),
    );
  }
}
