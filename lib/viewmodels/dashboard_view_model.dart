import 'package:dynadoc_front/network/jwt_key.dart';
import 'package:flutter/material.dart';

enum DashboardState { lista, crear, editar }

class DashboardViewModel extends ChangeNotifier {
  DashboardState _dashState = DashboardState.lista;

  DashboardState getDashboardState() {
    return _dashState;
  }

  void setDashboardState(DashboardState dashState) {
    _dashState = dashState;
    notifyListeners();
  }

  void logout() {
    _dashState = DashboardState.lista;
    JwtKey().clear();
  }
}
