import 'package:dynadoc_front/views/Dashboard/dashboard_view.dart';
import 'package:dynadoc_front/views/Login/login_view.dart';

var appRoutes = {
  '/login': (context) => const Loginview(),
  '/dashboard': (context) => const DashboardView(),
};
