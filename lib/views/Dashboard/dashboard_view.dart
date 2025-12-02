import 'package:dynadoc_front/viewmodels/dashboard_view_model.dart';
import 'package:dynadoc_front/views/Dashboard/new_template_widget.dart';
import 'package:dynadoc_front/views/Dashboard/template_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardViewModel viewModel = context.watch<DashboardViewModel>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, //Para que no aparezca el boton de back en el appbar
        backgroundColor: Color.fromARGB(255, 85, 17, 136),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90,
                  child: IconButton(
                    onPressed: () => {
                      viewModel.setDashboardState(DashboardState.lista),
                    },
                    icon: Image.asset("assets/images/logo-small-white.png"),
                  ),
                ),
                TextButton(
                  onPressed: () => {
                    viewModel.setDashboardState(DashboardState.lista),
                  },
                  child: Text(
                    "Ver plantillas",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => {
                    viewModel.setDashboardState(DashboardState.crear),
                  },
                  child: Text(
                    "Crear plantilla",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                viewModel.logout();
                Navigator.popAndPushNamed(context, "/login");
              },
              icon: Icon(Icons.exit_to_app, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          switch (viewModel.getDashboardState()) {
            case DashboardState.lista:
              return TemplateListWidget();
            case DashboardState.crear:
              return NewTemplateWidget();
          }
        },
      ),
    );
  }
}
