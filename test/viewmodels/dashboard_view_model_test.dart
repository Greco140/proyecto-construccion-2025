import 'package:flutter_test/flutter_test.dart';
import 'package:dynadoc_front/viewmodels/dashboard_view_model.dart';

void main() {
  group('DashboardViewModel Tests', () {
    late DashboardViewModel viewModel;

    setUp(() {
      viewModel = DashboardViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('DashboardViewModel initializes with lista state', () {
      expect(viewModel.getDashboardState(), equals(DashboardState.lista));
    });

    test('DashboardViewModel setDashboardState changes to crear', () {
      viewModel.setDashboardState(DashboardState.crear);
      expect(viewModel.getDashboardState(), equals(DashboardState.crear));
    });

    test('DashboardViewModel setDashboardState changes back to lista', () {
      viewModel.setDashboardState(DashboardState.crear);
      viewModel.setDashboardState(DashboardState.lista);
      expect(viewModel.getDashboardState(), equals(DashboardState.lista));
    });

    test('DashboardViewModel notifies listeners on state change', () {
      var notificationCount = 0;
      viewModel.addListener(() {
        notificationCount++;
      });

      viewModel.setDashboardState(DashboardState.crear);
      expect(notificationCount, equals(1));

      viewModel.setDashboardState(DashboardState.lista);
      expect(notificationCount, equals(2));
    });

    test('DashboardViewModel state transitions', () {
      viewModel.setDashboardState(DashboardState.crear);
      expect(viewModel.getDashboardState(), equals(DashboardState.crear));

      viewModel.setDashboardState(DashboardState.lista);
      expect(viewModel.getDashboardState(), equals(DashboardState.lista));

      viewModel.setDashboardState(DashboardState.crear);
      expect(viewModel.getDashboardState(), equals(DashboardState.crear));
    });

    test('DashboardViewModel has logout method', () {
      expect(viewModel.logout, isA<Function>());
    });

    test('DashboardViewModel supports both DashboardState values', () {
      final states = [DashboardState.lista, DashboardState.crear];

      for (final state in states) {
        viewModel.setDashboardState(state);
        expect(viewModel.getDashboardState(), equals(state));
      }
    });

    test('DashboardViewModel repeated state changes work correctly', () {
      for (int i = 0; i < 5; i++) {
        viewModel.setDashboardState(DashboardState.crear);
        expect(viewModel.getDashboardState(), equals(DashboardState.crear));

        viewModel.setDashboardState(DashboardState.lista);
        expect(viewModel.getDashboardState(), equals(DashboardState.lista));
      }
    });
  });
}
